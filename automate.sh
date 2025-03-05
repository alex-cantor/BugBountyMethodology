#!/bin/bash

DOMAIN="target.com"  # Set your target domain here
OUTPUT_DIR="output"  # Directory to store output

# Function to output headers for readability
output_header() {
  local text="$1"
  local bold="$2"
  local PADDING=4
  local length=$(expr length "$text")
  
  printf '%*s\n' $(($length + $PADDING)) '' | tr ' ' '#'
  if [ "$bold" == "true" ]; then
    printf '%*s\n' $(($length + $PADDING)) '' | tr ' ' '#'
  fi
  echo "# $text #"
  printf '%*s\n' $(($length + $PADDING)) '' | tr ' ' '#'
  if [ "$bold" == "true" ]; then
    printf '%*s\n' $(($length + $PADDING)) '' | tr ' ' '#'
  fi
}

# Install required tools
install_tools() {
  echo "Installing required tools for bug bounty hunting..."

  sudo apt update
  sudo apt install -y \
    golang \
    python3-pip \
    nmap \
    git \
    curl \
    jq \
    dirb \
    wpscan \
    ffuf \
    nikto

  # Install Go-based tools
  go install github.com/jaeles-project/gospider@latest
  go install github.com/projectdiscovery/naabu/v2/cmd/naabu@latest
  go install github.com/tomnomnom/httprobe@latest
  go install github.com/lukasikic/subjack@latest
  go install github.com/jaeles-project/nuclei/v2/cmd/nuclei@latest

  # Install Python-based tools
  pip3 install arjun paramspider
}

# Google Dorks function - Runs multiple Google Dorks to gather valuable information
google_dork() {
  local domain="$1"
  echo "Running Google Dorks for $domain..."

  dorks=(
    "site:*.${domain} -www"  # Subdomains
    "site:${domain} inurl:admin"  # Exposed admin panels
    "site:${domain} inurl:login"  # Exposed login pages
    "site:test.${domain}"  # Test environments
    "site:dev.${domain}"  # Dev environments
    "site:staging.${domain}"  # Staging environments
    "site:${domain} ext:conf | ext:cnf | ext:ini | ext:env"  # Configuration files
    "site:${domain} ext:bak | ext:old | ext:backup | ext:zip | ext:tar"  # Backup files
    "site:${domain} ext:sql | ext:db | ext:sqlite"  # SQL database dumps
    "site:${domain} inurl:.git"  # Exposed Git repositories
    "site:${domain} inurl:.svn"  # SVN repositories
    "site:${domain} ext:log"  # Exposed logs
    "site:${domain} ext:js intext:API_KEY"  # API keys in JavaScript
    "site:${domain} intext:\"AWS_ACCESS_KEY_ID\" | intext:\"AWS_SECRET_ACCESS_KEY\""  # AWS keys
    "site:${domain} intext:\"AIza\" OR intext:\"AIzaSy\""  # Google API keys
    "site:${domain} ext:php intext:\"password\""  # Hardcoded passwords in PHP files
    "site:${domain} ext:xls | ext:xlsx"  # Excel spreadsheets
    "site:${domain} ext:pdf"  # PDF files
    "site:${domain} ext:doc | ext:docx"  # Word documents
    "site:${domain} ext:csv"  # CSV files
    "site:${domain} \"error in your SQL syntax\""  # SQL errors
    "site:${domain} \"PHP Parse error\""  # PHP errors
    "site:${domain} intitle:\"index of\""  # Exposed directories
    "site:${domain} inurl:signin | inurl:signup | inurl:auth"  # Login pages
    "site:${domain} inurl:wp-admin"  # WordPress admin panel
    "site:${domain} inurl:jira"  # JIRA instances
    "site:${domain} inurl:wp-config.php"  # WordPress configuration file
    "site:${domain} inurl:configuration.php"  # Joomla configuration file
    "site:${domain} inurl:settings.php"  # Drupal configuration file
    "site:${domain} inurl:phpmyadmin"  # MySQL admin panel
    "site:${domain} inurl:27017"  # MongoDB instances
  )

  # Loop through the dorks and run them
  for dork in "${dorks[@]}"; do
    echo "Running Google Dork: $dork"
    curl -s "https://www.google.com/search?q=${dork}" -o "$OUTPUT_DIR/google_dork_results_$(echo $dork | tr -s ' ' '_').txt"
  done
}

# Example function to run everything
run_bug_bounty_hunt() {
  mkdir -p "$OUTPUT_DIR"  # Create output directory
  output_header "Running Bug Bounty Hunting Script" true
  google_dork "$DOMAIN"  # Run Google Dorks for the target domain
}

# Web Analyze (could be a tool or custom function)
web_analyze() {
  local domain="$1"
  echo "Running Web Analyze for $domain..."
  # Example with httprobe
  httprobe -p https://$domain -p http://$domain > "$OUTPUT_DIR/web_analyze.txt"
}

# Tool Functions

# Gospider
run_gospider() {
  echo "Running gospider for $DOMAIN..."
  gospider -s "$DOMAIN" -o "$OUTPUT_DIR/gospider_output" -c 50
}

# Naabu (Port Scanning)
run_naabu() {
  echo "Running naabu for $DOMAIN..."
  naabu -host "$DOMAIN" -o "$OUTPUT_DIR/naabu_output.txt"
}

# Shodan
run_shodan() {
  echo "Running Shodan for $DOMAIN..."
  shodan search "$DOMAIN" > "$OUTPUT_DIR/shodan_output.txt"
}

# GAU (Get all URLs)
run_gau() {
  echo "Running GAU for $DOMAIN..."
  gau "$DOMAIN" > "$OUTPUT_DIR/gau_output.txt"
}

# Arjun (For parameter enumeration)
run_arjun() {
  echo "Running Arjun for $DOMAIN..."
  arjun -u "$DOMAIN" -o "$OUTPUT_DIR/arjun_output.txt"
}

# Paramspider (For parameter discovery)
run_paramspider() {
  echo "Running Paramspider for $DOMAIN..."
  paramspider --domain "$DOMAIN" --output "$OUTPUT_DIR/paramspider_output.txt"
}

# KXSS (Check for XSS vulnerabilities)
run_kxss() {
  echo "Running KXSS for $DOMAIN..."
  kxss -u "$DOMAIN" > "$OUTPUT_DIR/kxss_output.txt"
}

# WPScan (If appropriate for WordPress)
run_wpscan() {
  if [[ "$DOMAIN" == *.wordpress.com* ]]; then
    echo "Running WPScan for $DOMAIN..."
    wpscan --url "$DOMAIN" --output "$OUTPUT_DIR/wpscan_output.txt"
  else
    echo "Skipping WPScan, not a WordPress site."
  fi
}

# Joomscan (If appropriate for Joomla)
run_joomscan() {
  if [[ "$DOMAIN" == *.joomla.com* ]]; then
    echo "Running Joomscan for $DOMAIN..."
    joomscan -u "$DOMAIN" > "$OUTPUT_DIR/joomscan_output.txt"
  else
    echo "Skipping Joomscan, not a Joomla site."
  fi
}

# Nuclei (For vulnerability scanning)
run_nuclei() {
  echo "Running Nuclei for $DOMAIN..."
  nuclei -u "$DOMAIN" -o "$OUTPUT_DIR/nuclei_output.txt"
}

# Main script

mkdir -p "$OUTPUT_DIR"  # Create output directory

# Header for initial setup
output_header "Bug Bounty Automation Script" true

# Installing required tools
output_header "Installing Required Tools" true
install_tools

# Running Recon and Analysis
output_header "Reconnaissance and Information Gathering" true
output_header "Tech Profiling"
# Add your tech profiling tool here, if you have one

output_header "WebAnalyze"
web_analyze "$DOMAIN"

# Running Various Tools
output_header "Running Bug Bounty Tools" true
run_bug_bounty_hunt
run_gospider
run_naabu
run_shodan
run_gau
run_arjun
run_paramspider
run_kxss
run_wpscan
run_joomscan
run_nuclei

echo "Bug bounty hunting script completed!"
