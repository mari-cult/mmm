EAPI=8

inherit cargo git-r3

DESCRIPTION="A GnuPG-compatible Sequoia Chameleon"
HOMEPAGE="https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg"
EGIT_REPO_URI="https://gitlab.com/sequoia-pgp/sequoia-chameleon-gnupg.git"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gpg"

RDEPEND="
	dev-libs/openssl:=
	dev-db/sqlite:3
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=virtual/rust-1.70.0
	dev-libs/capnproto
	sys-devel/clang
"

FIXED_SHELLEXPAND_GIT="https://gitlab.com/anthonycicc/rust-shellexpand"

src_unpack() {
	git-r3_src_unpack
	
	# Apply the patch to Cargo.toml IMMEDIATELY after unpacking the main repo
	# but BEFORE cargo starts fetching dependencies.
	cat >> "${S}/Cargo.toml" <<- _EOF_
[patch.crates-io]
shellexpand = { git = "${FIXED_SHELLEXPAND_GIT}", branch = "main" }
_EOF_

	# Now cargo_live_src_unpack will see the patch and 
	# fetch the git dependency while the network is still open.
	cargo_live_src_unpack
}

src_configure() {
	# Some Sequoia crates require specific environment variables for linking
	export LIB_SQLITE3_SYS_USE_PKG_CONFIG=1
	
	cargo_src_configure
}

src_compile() {
	cargo_src_compile
}

src_install() {
	cargo_src_install

	if use gpg; then
		dodir /usr/libexec/gpg-sq
		dosym ../../bin/gpg-sq /usr/libexec/gpg-sq/gpg
		dosym ../../bin/gpgv-sq /usr/libexec/gpg-sq/gpgv
	fi
	
	dodoc README.md
	
	find "$(cargo_target_dir)" -name "*.1" -exec doman {} +
}
