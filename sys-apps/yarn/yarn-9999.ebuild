EAPI=8

inherit cargo git-r3

DESCRIPTION="Fast, reliable, and secure dependency management (v6+ Rust rewrite)"
HOMEPAGE="https://github.com/yarnpkg/zpm"
EGIT_REPO_URI="https://github.com/yarnpkg/zpm"

LICENSE="GPL-3.0-or-later"
SLOT="0"
KEYWORDS=""

BDEPEND="|| ( dev-lang/rust-bin dev-lang/rust )"
RDEPEND=""

src_unpack() {
    git-r3_src_unpack
    cargo_live_src_unpack
}

src_configure() {
    cargo_src_configure
}

src_compile() {
    cargo_src_compile --frozen --package zpm
}

src_install() {
    cargo_src_install --frozen --path packages/zpm
    dosym yarn-bin /usr/bin/yarn
}

