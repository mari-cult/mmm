EAPI=8

inherit cargo git-r3

DESCRIPTION=""
EGIT_REPO_URI="https://github.com/jj-vcs/jj.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	dev-libs/openssl:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	llvm-core/clang
"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install --path cli
}
