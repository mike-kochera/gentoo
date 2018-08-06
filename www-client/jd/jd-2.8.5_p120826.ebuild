# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils autotools flag-o-matic

MY_P="${P/_p/-}"

DESCRIPTION="gtk2 based 2ch browser written in C++"
HOMEPAGE="http://jd4linux.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/${PN}4linux/56721/${MY_P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa gnome gnutls migemo"

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/glib:2
	sys-libs/zlib
	x11-misc/xdg-utils
	alsa? ( >=media-libs/alsa-lib-1 )
	gnome? ( >=gnome-base/libgnomeui-2 )
	!gnome? (
		x11-libs/libSM
		x11-libs/libICE
	)
	gnutls? ( net-libs/gnutls )
	!gnutls? ( dev-libs/openssl:0 )
	migemo? ( app-text/cmigemo )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	append-cxxflags -std=c++11

	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		$(use_with alsa) \
		$(use_with gnome sessionlib gnomeui) \
		$(use_with !gnome sessionlib xsmp) \
		$(use_with !gnutls openssl) \
		$(use_with migemo) \
		$(use_with migemo migemodict "${EREPFIX}"/usr/share/migemo/migemo-dict) \
		--with-xdgopen
}

src_install() {
	default
	doicon ${PN}.png
	domenu ${PN}.desktop
}
