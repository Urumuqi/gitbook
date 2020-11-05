build:
	rm -rf _book
	gitbook build
clean:
	rm -rf _book
	rm -rf gitbook.tar.gz
pack: _book
	tar zcf gitbook.tar.gz _book
	scp gitbook.tar.gz blog@blog:/home/www/blog/