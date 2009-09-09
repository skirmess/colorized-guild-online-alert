
.PHONY: clean tag release

VERSION=1

clean:
	rm -f *~

tag: clean
	cvs tag ColorizedGuildOnlineAlert-$(VERSION)

release: clean
	( cd ..;							\
		rm -f ColorizedGuildOnlineAlert-$(VERSION).zip;		\
		find ColorizedGuildOnlineAlert				\
				-name CVS -prune -o			\
				-name .svn -prune -o			\
				-name Makefile -prune -o		\
				-name '.*.swp' -prune -o		\
				-print					\
		| zip -@ ColorizedGuildOnlineAlert-$(VERSION).zip;	\
	)	
