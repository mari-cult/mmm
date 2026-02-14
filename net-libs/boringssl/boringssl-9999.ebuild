EAPI=8

PYTHON_COMPAT=( python3_{10..14} )
inherit cmake git-r3 python-any-r1 flag-o-matic

DESCRIPTION="A fork of OpenSSL (Isolated in /opt/boringssl)"
HOMEPAGE="https://boringssl.googlesource.com/boringssl/"
EGIT_REPO_URI="https://boringssl.googlesource.com/boringssl"

LICENSE="ISC openssl SSLeay MIT"
SLOT="0"
IUSE="test"

BDEPEND="
	${PYTHON_DEPS}
	dev-lang/perl
"

# Define the isolated path
PREFIX_DIR="/opt/boringssl"

src_prepare() {
	find . \( -name "CMakeLists.txt" -o -name "*.cmake" \) \
			-exec sed -i 's/-Werror/-Wno-error/g' {} + || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_TESTING=OFF
		-DCMAKE_INSTALL_PREFIX="${PREFIX_DIR}"
		-DCMAKE_INSTALL_RPATH="${PREFIX_DIR}/$(get_libdir)"
		-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON
	)
	cmake_src_configure
}

src_install() {
  cmake_src_install

  cat >> "${T}/99boringssl" <<- _EOF_ || die
		PATH="${PREFIX_DIR}/bin"
		ROOTPATH="${PREFIX_DIR}/bin"
		LDPATH="${PREFIX_DIR}/$(get_libdir)"
	_EOF_

	doenvd "${T}/99boringssl"
}
