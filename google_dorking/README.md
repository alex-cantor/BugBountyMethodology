# Google Dorking

We can use Google Dorking to find valuable information on the internet, with a customized, targeted Google search (or Dork)!

---

## Useful Dorks

Here are a few of the many Google Dorks we can use to find valuable information:

### Subdomain & Site Enumeration
Find all indexed subdomains of a target:
```
site:*.target.com -www
```
Find exposed admin panels or login pages:
```
site:target.com inurl:admin
site:target.com inurl:login
```
Find test environments and dev sites:
```
site:test.target.com
site:dev.target.com
site:staging.target.com
```

### Exposed Sensitive Files
Find exposed configuration files:
```
site:target.com ext:conf | ext:cnf | ext:ini | ext:env
```
Find backup files (may contain credentials):
```
site:target.com ext:bak | ext:old | ext:backup | ext:zip | ext:tar
```
Search for database dumps:
```
site:target.com ext:sql | ext:db | ext:sqlite
```
Find exposed Git repositories:
```
site:target.com inurl:.git``` ```site:target.com inurl:.svn
```
Find leaked logs:
```
site:target.com ext:log
```

### API Keys & Credentials
Look for API keys in JavaScript files:
```
site:target.com ext:js intext:API_KEY
```
Find AWS keys:
```
site:target.com intext:"AWS_ACCESS_KEY_ID" | intext:"AWS_SECRET_ACCESS_KEY"
```
Look for Google API keys:
```
site:target.com intext:"AIza" OR intext:"AIzaSy"
```
Find hardcoded credentials in PHP:
```
site:target.com ext:php intext:"password"
```

### Exposed Documents & Data
Find Excel spreadsheets (possible sensitive data):
```
site:target.com ext:xls | ext:xlsx
```
Find PDF files (may contain internal info):
```
site:target.com ext:pdf
```
Find Word documents:
```
site:target.com ext:doc | ext:docx
```
Find CSV files (potential credentials or user data):
```
site:target.com ext:csv
```

### Error Messages & Debug Pages
Find error messages (useful for identifying technologies):
```
site:target.com "error in your SQL syntax"
site:target.com "PHP Parse error"
```
Find exposed directories:
```
site:target.com intitle:"index of"
```

### Web App Testing
Search for login pages on the target:
```
site:target.com inurl:signin | inurl:signup | inurl:auth
```
Find WordPress admin panels:
```
site:target.com inurl:wp-admin
```
Find JIRA instances (may expose tickets):
```
site:target.com inurl:jira
```


### Finding Vulnerable Files in CMS
Find WordPress configuration files:
```
site:target.com inurl:wp-config.php
```
Find Joomla configuration files:
```
site:target.com inurl:configuration.php
```
Find Drupal configuration files:
```
site:target.com inurl:settings.php
```

### Miscellaneous
Find exposed MySQL administration panels:
```
site:target.com inurl:phpmyadmin
```
Find exposed MongoDB instances:
```
site:target.com inurl:27017
```

### More Google Dorks
GHDB (Google Hacking Database) – Use Exploit-DB’s Dork Database for new queries.
📌 Google Hacking Database
