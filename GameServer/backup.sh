#!/bin/bash
tmp_dir=$(mktemp -d -t backup-XXXXXXXXXX)
tmp_file=$tmp_dir/fifthcolumnist.duckdns.org.tar.gz
cd /home/ubuntu
tar -czf $tmp_file vintage-story/data/*
s3cmd --human-readable-sizes --no-progress --access_key=AKIARXJZU4B4U62R2SDA --secret_key=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 put $tmp_file s3://vintage-story-backup
rm -rf $tmp_dir