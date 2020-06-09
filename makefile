PREFIX=$(HOME)/.local
BINDIR=$(PREFIX)/bin
LIBDIR=$(PREFIX)/share
MACDIR=$(LIBDIR)/tmac
TROFF=$(BINDIR)/roff
UGRIND=$(BINDIR)/ugrind
PREXML=$(BINDIR)/prexml
POSTXML=$(BINDIR)/postxml
NROFF=groff -k -Tutf8 -M$(MACDIR)
SOELIM=soelim
XSLT=utroff.xsl
WEBDIR=docs
MANDIR=$(WEBDIR)/man
PUBDIR=$(WEBDIR)/pub
WEBURL=https://pjfichet.github.io/utroff
MANURL=$(WEBURL)/man
PUBURL=$(WEBURL)/pub
#WEBURL=http://utroff.org
#PUBURL=http://download.tuxfamily.org/utroff

MANFILES=idx hunt inv mkey referformat refer sortbib \
tchars ugrind u-ref utmac-hack utmac troffxml \
bsd4 cddl isc tsql

WEBFILES=bin index tmac xml

PUBFILES=layout-ul.pdf layout-us.pdf layout-uh.pdf

WEB= $(MANFILES:%=$(WEBDIR)/man/%.html) \
	$(WEBFILES:%=$(WEBDIR)/%.html) \
	$(PUBFILES:%=$(PUBDIR)/%) \
	$(WEBDIR)/utroff.css

help:
	@echo web|unweb man clean

web: $(WEBDIR) $(MANDIR) $(PUBDIR) $(WEB)

unweb:
	rm -rf $(WEB)
	rmdir $(MANDIR)
	rmdir $(PUBDIR)
	rmdir $(WEBDIR)

%.xml: %.tr
	$(UGRIND) $< | $(PREXML) | $(NROFF) -mux | $(POSTXML) > $@

%.html: %.xml $(XSLT)
	@xsltproc $(XSLT) $< \
		| sed -e "s#@WEBURL@#$(WEBURL)#g; \
			s#@PUBURL@#$(PUBURL)#g; \
			s#@MANURL@#$(MANURL)#g" > $@

$(WEBDIR) $(MANDIR) $(PUBDIR):
	@mkdir -p $@

$(WEBDIR)/% $(MANDIR)/% $(PUBDIR)/%: %
	install -c -m 644 $< $@

man: $(MANFILES:%=%.man)

%.man: %.tr
	$(UGRIND) $< | $(NROFF) -mum > $@

installman: man
	cp idx.man ../idx/
	cp hunt.man ../refer/
	cp inv.man ../refer/
	cp mkey.man ../refer/
	cp referformat.man ../refer/
	cp refer.man ../refer/
	cp sortbib.man ../refer/
	cp tchars.man ../tchars/
	cp ugrind.man ../ugrind/
	cp u-ref.man ../utmac/
	cp utmac-hack.man ../utmac/
	cp utmac.man ../utmac/
	cp troffxml.man ../troffxml/
	cp tsql.man ../tsql/

clean:
	@rm -f $(WEBFILES:%=%.html) $(MANFILES:%=%.html)
	@rm -f $(MANFILES:%=%.man)

SSHURL=ssh.tuxfamily.org
SSHWEB=$(SSHURL):/home/utroff/utroff.org-web/htdocs
SSHPUB=$(SSHURL):/home/utroff/utroff-repository
scp:
	scp -r $(WEBDIR)/* $(SSHUSER)@$(SSHWEB)/

