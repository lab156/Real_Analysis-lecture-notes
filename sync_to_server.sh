source ../course_info
if [ -n "$SYNCTOSERVER" ]; then
    echo "......syncing.......";
    cp this_paper.pdf /srv/http/this_paper.pdf ;
else
    echo "...NO SYNC WILL BE DONE...";
fi
