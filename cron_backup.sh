tmpdir=$(mktemp --directory)

for user_id in $TTRSS_BACKUP_USER_IDS; do
  domain="$(echo $TTRSS_SELF_URL_PATH | sed 's|^https:||' | sed 's|/||g')"
  php tinytinyrss-backup.php $user_id > "$tmpdir/$domain.user.$user_id.opml"
  bash update_git_repo.bash "$tmpdir"
done
