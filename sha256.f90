! Pure Fortran SHA-256 (deterministic, no external dependencies)
!
! Exports:
!   sha256_hex_text(text)   -> 64-char lowercase hex digest of a Fortran string (bytes = iachar per char)
!   sha256_hex_bytes(bytes) -> 64-char lowercase hex digest of raw bytes
!
! Notes:
! - Uses int64 internally with explicit 32-bit masking to avoid undefined overflow behavior.
! - Lowercase hex output.
! - u32 is ELEMENTAL so it works on both scalars and arrays.

module sha256
  use iso_fortran_env, only: int8, int64
  implicit none
  private

  public :: sha256_hex_text, sha256_hex_bytes

  integer(int64), parameter :: MASK32 = int(Z'FFFFFFFF', int64)

  integer(int64), parameter :: K(64) = [ &
    int(Z'428A2F98',int64), int(Z'71374491',int64), int(Z'B5C0FBCF',int64), int(Z'E9B5DBA5',int64), &
    int(Z'3956C25B',int64), int(Z'59F111F1',int64), int(Z'923F82A4',int64), int(Z'AB1C5ED5',int64), &
    int(Z'D807AA98',int64), int(Z'12835B01',int64), int(Z'243185BE',int64), int(Z'550C7DC3',int64), &
    int(Z'72BE5D74',int64), int(Z'80DEB1FE',int64), int(Z'9BDC06A7',int64), int(Z'C19BF174',int64), &
    int(Z'E49B69C1',int64), int(Z'EFBE4786',int64), int(Z'0FC19DC6',int64), int(Z'240CA1CC',int64), &
    int(Z'2DE92C6F',int64), int(Z'4A7484AA',int64), int(Z'5CB0A9DC',int64), int(Z'76F988DA',int64), &
    int(Z'983E5152',int64), int(Z'A831C66D',int64), int(Z'B00327C8',int64), int(Z'BF597FC7',int64), &
    int(Z'C6E00BF3',int64), int(Z'D5A79147',int64), int(Z'06CA6351',int64), int(Z'14292967',int64), &
    int(Z'27B70A85',int64), int(Z'2E1B2138',int64), int(Z'4D2C6DFC',int64), int(Z'53380D13',int64), &
    int(Z'650A7354',int64), int(Z'766A0ABB',int64), int(Z'81C2C92E',int64), int(Z'92722C85',int64), &
    int(Z'A2BFE8A1',int64), int(Z'A81A664B',int64), int(Z'C24B8B70',int64), int(Z'C76C51A3',int64), &
    int(Z'D192E819',int64), int(Z'D6990624',int64), int(Z'F40E3585',int64), int(Z'106AA070',int64), &
    int(Z'19A4C116',int64), int(Z'1E376C08',int64), int(Z'2748774C',int64), int(Z'34B0BCB5',int64), &
    int(Z'391C0CB3',int64), int(Z'4ED8AA4A',int64), int(Z'5B9CCA4F',int64), int(Z'682E6FF3',int64), &
    int(Z'748F82EE',int64), int(Z'78A5636F',int64), int(Z'84C87814',int64), int(Z'8CC70208',int64), &
    int(Z'90BEFFFA',int64), int(Z'A4506CEB',int64), int(Z'BEF9A3F7',int64), int(Z'C67178F2',int64)  &
  ]

contains

  elemental pure integer(int64) function u32(x) result(r)
    integer(int64), intent(in) :: x
    r = iand(x, MASK32)
  end function u32

  pure integer(int64) function add32(a,b,c,d,e) result(r)
    integer(int64), intent(in), optional :: a,b,c,d,e
    integer(int64) :: s
    s = 0_int64
    if (present(a)) s = s + a
    if (present(b)) s = s + b
    if (present(c)) s = s + c
    if (present(d)) s = s + d
    if (present(e)) s = s + e
    r = u32(s)
  end function add32

  pure integer(int64) function rotr32(x,n) result(r)
    integer(int64), intent(in) :: x
    integer, intent(in) :: n
    integer(int64) :: v
    v = u32(x)
    r = u32( ior( ishft(v, -n), ishft(v, 32-n) ) )
  end function rotr32

  pure integer(int64) function shr32(x,n) result(r)
    integer(int64), intent(in) :: x
    integer, intent(in) :: n
    r = u32( ishft(u32(x), -n) )
  end function shr32

  pure integer(int64) function ch(x,y,z) result(r)
    integer(int64), intent(in) :: x,y,z
    r = ieor( iand(u32(x),u32(y)), iand(not(u32(x)),u32(z)) )
    r = u32(r)
  end function ch

  pure integer(int64) function maj(x,y,z) result(r)
    integer(int64), intent(in) :: x,y,z
    r = ieor( ieor(iand(u32(x),u32(y)), iand(u32(x),u32(z))), iand(u32(y),u32(z)) )
    r = u32(r)
  end function maj

  pure integer(int64) function big_sigma0(x) result(r)
    integer(int64), intent(in) :: x
    r = ieor( ieor(rotr32(x,2), rotr32(x,13)), rotr32(x,22) )
    r = u32(r)
  end function big_sigma0

  pure integer(int64) function big_sigma1(x) result(r)
    integer(int64), intent(in) :: x
    r = ieor( ieor(rotr32(x,6), rotr32(x,11)), rotr32(x,25) )
    r = u32(r)
  end function big_sigma1

  pure integer(int64) function small_sigma0(x) result(r)
    integer(int64), intent(in) :: x
    r = ieor( ieor(rotr32(x,7), rotr32(x,18)), shr32(x,3) )
    r = u32(r)
  end function small_sigma0

  pure integer(int64) function small_sigma1(x) result(r)
    integer(int64), intent(in) :: x
    r = ieor( ieor(rotr32(x,17), rotr32(x,19)), shr32(x,10) )
    r = u32(r)
  end function small_sigma1

  pure subroutine to_lower_hex(str)
    character(len=*), intent(inout) :: str
    integer :: i, c
    do i = 1, len(str)
      c = iachar(str(i:i))
      if (c >= iachar('A') .and. c <= iachar('F')) then
        str(i:i) = achar(c + 32)
      end if
    end do
  end subroutine to_lower_hex

  function sha256_hex_text(text) result(hex)
    character(len=*), intent(in) :: text
    character(len=64) :: hex
    integer(int8), allocatable :: b(:)
    integer :: i, n

    n = len(text)
    allocate(b(n))
    do i = 1, n
      b(i) = int(iachar(text(i:i)), int8)
    end do

    hex = sha256_hex_bytes(b)
    deallocate(b)
  end function sha256_hex_text

  function sha256_hex_bytes(bytes) result(hex)
    integer(int8), intent(in) :: bytes(:)
    character(len=64) :: hex

    integer(int8), allocatable :: msg(:)
    integer(int64) :: bitlen
    integer :: n, newlen, i, j, offset
    integer(int64) :: Hstate(8)
    integer(int64) :: W(64)
    integer(int64) :: a,b,c,d,e,f,g,hh,t1,t2
    character(len=8) :: part

    ! Initial hash values
    Hstate = [ &
      int(Z'6A09E667',int64), int(Z'BB67AE85',int64), int(Z'3C6EF372',int64), int(Z'A54FF53A',int64), &
      int(Z'510E527F',int64), int(Z'9B05688C',int64), int(Z'1F83D9AB',int64), int(Z'5BE0CD19',int64)  &
    ]
    Hstate = u32(Hstate)

    n = size(bytes)
    bitlen = int(n, int64) * 8_int64

    ! Pad: append 0x80, then zeros, then 64-bit big-endian bit length
    newlen = n + 1
    do while (mod(newlen + 8, 64) /= 0)
      newlen = newlen + 1
    end do

    allocate(msg(newlen + 8))
    msg = 0_int8
    if (n > 0) msg(1:n) = bytes
    msg(n+1) = int(Z'80', int8)

    do i = 0, 7
      msg(newlen + 8 - i) = int( iand( ishft(bitlen, -8*i), int(Z'FF',int64) ), int8 )
    end do

    ! Process each 512-bit block
    do offset = 1, size(msg), 64

      ! Prepare message schedule W[1..64]
      do i = 1, 16
        j = offset + (i-1)*4
        W(i) = u32( &
          ishft(int(iand(int(msg(j  ),int64),int(Z'FF',int64)),int64),24) + &
          ishft(int(iand(int(msg(j+1),int64),int(Z'FF',int64)),int64),16) + &
          ishft(int(iand(int(msg(j+2),int64),int(Z'FF',int64)),int64), 8) + &
               int(iand(int(msg(j+3),int64),int(Z'FF',int64)),int64) )
      end do

      do i = 17, 64
        W(i) = add32( small_sigma1(W(i-2)), W(i-7), small_sigma0(W(i-15)), W(i-16) )
      end do

      a  = Hstate(1); b  = Hstate(2); c  = Hstate(3); d  = Hstate(4)
      e  = Hstate(5); f  = Hstate(6); g  = Hstate(7); hh = Hstate(8)

      do i = 1, 64
        t1 = add32(hh, big_sigma1(e), ch(e,f,g), K(i), W(i))
        t2 = add32(big_sigma0(a), maj(a,b,c))
        hh = g
        g  = f
        f  = e
        e  = add32(d, t1)
        d  = c
        c  = b
        b  = a
        a  = add32(t1, t2)
      end do

      Hstate(1) = add32(Hstate(1), a)
      Hstate(2) = add32(Hstate(2), b)
      Hstate(3) = add32(Hstate(3), c)
      Hstate(4) = add32(Hstate(4), d)
      Hstate(5) = add32(Hstate(5), e)
      Hstate(6) = add32(Hstate(6), f)
      Hstate(7) = add32(Hstate(7), g)
      Hstate(8) = add32(Hstate(8), hh)

    end do

    deallocate(msg)

    ! Produce hex digest (lowercase)
    hex = ""
    do i = 1, 8
      write(part, "(Z8.8)") int(Hstate(i), int64)
      call to_lower_hex(part)
      hex((i-1)*8+1:i*8) = part
    end do

  end function sha256_hex_bytes

end module sha256