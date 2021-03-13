#!/bin/sh

PARAM=${1:-1}

START_PAGE=1
END_PAGE=1

if [[ "$PARAM" == *"-"* ]]; then
    TOKENS=(${PARAM//-/ })
    START_PAGE=${TOKENS[0]}
    END_PAGE=${TOKENS[1]}
else
    START_PAGE=$PARAM
    END_PAGE=$PARAM
fi

download_from_page () {
    PAGE=$1
    echo "Downloading from page $PAGE"

    PAGE_FILE="$TMPDIR/page"
    LINKS_FILE="$TMPDIR/links"
    URL="https://jbzd.com.pl/str/$PAGE"

    wget -q -O - -o /dev/null $URL > $PAGE_FILE 
    cat $PAGE_FILE | grep -i 'img.*article-image' | cut -d \" -f2 > $LINKS_FILE
    cat $PAGE_FILE | grep -i 'source' | cut -d \" -f2 >> $LINKS_FILE
    wget -q -i $LINKS_FILE -P output
}

cleanup() {
    rm $PAGE_FILE $LINKS_FILE
}


for ((i=$START_PAGE;i<=$END_PAGE;i++)); do
    download_from_page $i
  done

cleanup

