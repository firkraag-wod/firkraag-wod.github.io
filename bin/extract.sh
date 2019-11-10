#/bin/bash

# removes img sources and the rateblock from a saved kb
# for all kbs from the last three days up to today

from=$(date -d '1 day ago' +'%F')
froms=$(echo `date +'%F'`  `date -d '1 day ago' +'%F'` `date -d '2 day ago' +'%F'` `date -d '3 day ago' +'%F'` `date -d '4 day ago' +'%F'` `date -d '5 day ago' +'%F'` `date -d '6 day ago' +'%F'` `date -d '7 day ago' +'%F'`)

for day in $froms ; do
echo $day
[ -d archive/$day ] || continue
for file in archive/$day/*/* ; do
echo "Minifying $file"
cat ${file} |\
  perl -pe 's|[\n\r]||g;' |\
  perl -pe '
            s|(src="data:image/(.*?)")|src=""|ig; \
            s|(src=data:image(.*?)>)|src=""|ig; \
            s|url[(]"data:image(.*?)"[)]|url()|ig; \
            s|url[(]data:image(.*?)[)]|url()|ig; \
            s|"data:image(.*?)"|""|ig; \
            s|<div class="rateblock">(.*?)</div>||ig; \
            s|<div class=rateblock>(.*?)</div>||sg;' > ${file}.min
done
done


# only remove background image and header, left menu

for file in *.html
do
cat $file | perl -pe ' s|page_bg_with_image\{background:url\(data:image/jpeg;base64,.*?\)|page_bg_with_image{background:url(data:image/jpeg;base64,)|ig;' > $file.$$
mv -vf $file.$$ $file
sed -i  '46,570d' $file
done

