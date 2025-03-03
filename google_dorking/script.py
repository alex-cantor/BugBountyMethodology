import os
import time
import random
import datetime
from googlesearch import search

# Define target domain (Modify this to suit your target)
TARGET = "target.com"

# Google Dorks categorized for bug bounty
DORKS = {
    "Subdomains": [
        f"site:*.{TARGET} -www",
    ],
    "Admin Panels & Login Pages": [
        f"site:{TARGET} inurl:admin",
        f"site:{TARGET} inurl:login",
    ],
    "Sensitive Files": [
        f"site:{TARGET} ext:conf | ext:cnf | ext:ini | ext:env",
        f"site:{TARGET} ext:bak | ext:old | ext:backup | ext:zip | ext:tar",
        f"site:{TARGET} ext:sql | ext:db | ext:sqlite",
        f"site:{TARGET} inurl:.git",
        f"site:{TARGET} inurl:.svn",
        f"site:{TARGET} ext:log",
    ],
    "API Keys & Credentials": [
        f"site:{TARGET} ext:js intext:API_KEY",
        f"site:{TARGET} intext:'AWS_ACCESS_KEY_ID' | intext:'AWS_SECRET_ACCESS_KEY'",
        f"site:{TARGET} intext:'AIza' OR intext:'AIzaSy'",
        f"site:{TARGET} ext:php intext:'password'",
    ],
    "Documents & Internal Data": [
        f"site:{TARGET} ext:xls | ext:xlsx",
        f"site:{TARGET} ext:pdf",
        f"site:{TARGET} ext:doc | ext:docx",
        f"site:{TARGET} ext:csv",
    ],
    "Error Messages & Debug Info": [
        f"site:{TARGET} 'error in your SQL syntax'",
        f"site:{TARGET} 'PHP Parse error'",
        f"site:{TARGET} intitle:'index of'",
    ],
}

# Output directory for reports
OUTPUT_DIR = "dork_results"
if not os.path.exists(OUTPUT_DIR):
    os.makedirs(OUTPUT_DIR)

# Generate a timestamped filename
timestamp = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
output_file = os.path.join(OUTPUT_DIR, f"results_{TARGET}_{timestamp}.txt")

def perform_dorking():
    """Executes Google Dorks and saves results"""
    print(f"Running Google Dorking on {TARGET}...")

    with open(output_file, "w", encoding="utf-8") as f:
        for category, queries in DORKS.items():
            print(f"\nSearching for {category}...")
            f.write(f"\n### {category} ###\n")
            
            for dork in queries:
                print(f"   Query: {dork}")

                try:
                    results = list(search(dork, num_results=10, lang="en"))

                    if results:
                        print(f"   Found {len(results)} results!")
                        for result in results:
                            print(f"      {result}")
                            f.write(result + "\n")
                    else:
                        print("   No results found.")

                except Exception as e:
                    print(f"   Error querying {dork}: {e}")

                time.sleep(random.uniform(2, 5))  # Avoid rate-limiting

    print(f"\nResults saved in: {output_file}")

if __name__ == "__main__":
    perform_dorking()
