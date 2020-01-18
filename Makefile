all: script clearsign

script:
	gsed -e '/#####SCRIPT/{r setup.sh' -e 'd}' source.html > output.html

clearsign: 
	gpg --output index.html --clearsign output.html
