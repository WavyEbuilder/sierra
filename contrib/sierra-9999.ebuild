# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Local system SELinux policy"
HOMEPAGE="https://github.com/WavyEbuilder/sierra"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/WavyEbuilder/${PN}.git"
else
	KEYWORDS="~amd64"
	SRC_URI="https://github.com/WavyEbuilder/${PN}/releases/download/v${PV}/${P}.tar.xz"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+mcs"

src_configure() {
	eautoreconf
	econf $(use_enable mcs)
}
