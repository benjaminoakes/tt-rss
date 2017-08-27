tmpdir=$(mktemp --directory)

for user_id in $TTRSS_BACKUP_USER_IDS; do
  php tinytinyrss-backup.php $user_id > "$tmpdir/user-$user_id.opml"
  LANG=en_US.UTF-8 ruby update_gist.rb "$tmpdir/user-$user_id.opml"
done
