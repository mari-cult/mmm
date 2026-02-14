EAPI=8

inherit cargo git-r3

DESCRIPTION="Native WebGPU implementation based on wgpu-core (Rust)"
HOMEPAGE="https://github.com/gfx-rs/wgpu-native"
EGIT_REPO_URI="https://github.com/gfx-rs/wgpu-native"

LICENSE="Apache-2.0 MIT"
SLOT="0"

RDEPEND="media-libs/vulkan-loader"
DEPEND="${RDEPEND}"
BDEPEND=">=virtual/rust-1.92.0"

QA_FLAGS_IGNORED="usr/lib.*/libwgpu_native.so"

src_unpack() {
    git-r3_src_unpack
    cargo_live_src_unpack
}

src_compile() {
    # Build the dynamic library by default
    cargo_src_compile --lib
}

src_install() {
    # Install the library
    dolib.so "target/release/libwgpu_native.so"

    # Install standard WebGPU and wgpu-specific headers
    insinto /usr/include/webgpu
    doins ffi/webgpu-headers/webgpu.h
    doins ffi/wgpu.h

    local pc_file="${T}/wgpu-native.pc"
    cat <<EOF > "${pc_file}"
prefix=${EPREFIX}/usr
exec_prefix=\${prefix}
libdir=\${exec_prefix}/$(get_libdir)
includedir=\${prefix}/include

Name: wgpu-native
Description: Native WebGPU implementation (Rust)
Version: ${PV}
Libs: -L\${libdir} -lwgpu_native
Cflags: -I\${includedir}/webgpu
EOF

    insinto /usr/$(get_libdir)/pkgconfig
    doins "${pc_file}"
}
