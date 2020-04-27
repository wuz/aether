all: minify add_script clearsign cleanup

# Add sh script
add_script: $(eval SHELL:=/bin/bash)
	gsed -e '/__SCRIPT__/{r setup.sh' -e 'd}' tmp.html > output.html

# Add and Minifiy CSS
minify: $(eval SHELL:=/bin/bash)
	cat site.css | \
	gsed -e "s#/\*\(\\\\\)\?\*/#/~\1~/#g" -e "s#/\*[^*]*\*\+\([^/][^*]*\*\+\)*/##g" -e "s#\([^:/]\)//.*\1##" -e "s#^//.*##" | tr '\n' ' ' | \
  gsed -e "s#/\*[^*]*\*\+\([^/][^*]*\*\+\)*/##g" -e "s#/\~\(\\\\\)\?\~/#/*\1*/#g" \
  -e "s#\s\+# #g" -e "s# \([{;:,]\)#\1#g" -e "s#\([{;:,]\) #\1#g" > tmp.css
	gsed -e '/__SITECSS__/{r tmp.css' -e 'd}' source.html > tmp.html


clearsign: 
	gpg --output index.html --clearsign output.html

cleanup:
	rm tmp.*
