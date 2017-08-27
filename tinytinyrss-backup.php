<?php
  // Summary: Export OPML for user ID.  (A little like Google Takeout.)  Intended for a cron job or other command line usage.
  // 
  // Usage: php tinytinyrss-backup.php 1

	set_include_path(dirname(__FILE__) ."/include" . PATH_SEPARATOR .
		get_include_path());

	require_once "autoload.php";
	require_once "functions.php";
	require_once "sessions.php";
	require_once "sanity_check.php";
	require_once "config.php";
	require_once "db.php";
	require_once "db-prefs.php";

	if (!init_plugins()) return;

	$opml = new Opml(null);
	$opml->opml_export("", $argv[1]);
?>
