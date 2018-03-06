TORQUE_VERSION = 6.1.2
MAUI_VERSION = 3.3.1

TORQUE_PREFIX = /opt/torque
MAUI_PREFIX = /opt/maui

ARCH = x86_64
TORQUE_DIST = torque-$(TORQUE_VERSION)
MAUI_DIST = maui-$(MAUI_VERSION)
TORQUE_DISTFILE = $(TORQUE_DIST).tar.gz
MAUI_DISTFILE = $(MAUI_DIST).tar.gz
TORQUE_DISTURL = http://wpfilebase.s3.amazonaws.com/torque/$(TORQUE_DISTFILE)

.PHONY: all clean

all: .torque.ok .maui.ok
	:

.torque.ok: SOURCES/$(TORQUE_DISTFILE) \
            SPECS/torque.spec          \
            .rpmbuild-torque.ok
	docker run --rm -it -v "$${PWD}:/home/builder/rpmbuild"               \
	           rpmbuild-torque -D "_builddir     /tmp/rpmbuild/BUILD"     \
	                           -D "_buildrootdir /tmp/rpmbuild/BUILDROOT" \
	                           -D "_prefix       $(TORQUE_PREFIX)"        \
	                           -ba SPECS/torque.spec
	touch "$@"

.maui.ok: SOURCES/$(MAUI_DISTFILE) \
          SPECS/maui.spec          \
          .rpmbuild-maui.ok
	docker run --rm -it -v "$${PWD}:/home/builder/rpmbuild"             \
	           rpmbuild-maui -D "_builddir     /tmp/rpmbuild/BUILD"     \
	                         -D "_buildrootdir /tmp/rpmbuild/BUILDROOT" \
	                         -D "_prefix       $(MAUI_PREFIX)"          \
	                         -ba SPECS/maui.spec
	touch "$@"

.rpmbuild-torque.ok: rpmbuild-torque/Dockerfile
	docker build -t rpmbuild-torque rpmbuild-torque
	touch "$@"

.rpmbuild-maui.ok: rpmbuild-maui/Dockerfile \
                   rpmbuild-maui/torque.rpm \
                   rpmbuild-maui/torque-devel.rpm
	docker build -t rpmbuild-maui rpmbuild-maui
	touch "$@"

rpmbuild-maui/torque.rpm: .torque.ok
	cp RPMS/$(ARCH)/torque-$(TORQUE_VERSION)-*.rpm "$@"

rpmbuild-maui/torque-devel.rpm: .torque.ok
	cp RPMS/$(ARCH)/torque-devel-$(TORQUE_VERSION)-*.rpm "$@"

SOURCES/$(TORQUE_DISTFILE):
	curl -fsSL -o "$@" "$(TORQUE_DISTURL)"

SOURCES/$(MAUI_DISTFILE):
	@echo "Please manually download Maui distfile"
	@false

SPECS/torque.spec: SOURCES/$(TORQUE_DISTFILE)
	tar -Oxzf "$<" "$(TORQUE_DIST)/torque.spec" > "$@"

SPECS/maui.spec: SPECS/maui.spec.in
	sed -e "s|@VERSION@|$(MAUI_VERSION)|"        \
	    -e "s|@TORQUE_PREFIX@|$(TORQUE_PREFIX)|" \
	    "$<" > "$@"
