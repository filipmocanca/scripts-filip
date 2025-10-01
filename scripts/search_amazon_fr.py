"""
Simple script to search for a product on Amazon France using a user prompt.

This opens the default web browser to the Amazon.fr search results page for the
entered query. No scraping or automation is performed.
"""

from __future__ import annotations

import sys
import webbrowser
from urllib.parse import quote_plus


def build_amazon_fr_search_url(query: str) -> str:
    """Return the Amazon.fr search URL for the given query.

    Uses `quote_plus` to safely encode spaces and special characters.
    """
    encoded = quote_plus(query.strip())
    return f"https://www.amazon.fr/s?k={encoded}"


def prompt_for_query() -> str:
    """Prompt the user for a product query and return it.

    If the user enters an empty string, the function will keep prompting.
    """
    while True:
        try:
            query = input("Enter the product you want to search on Amazon.fr: ").strip()
        except (EOFError, KeyboardInterrupt):
            print("\nOperation cancelled.")
            sys.exit(1)

        if query:
            return query
        print("Please enter a non-empty product name.")


def main() -> None:
    query = prompt_for_query()
    url = build_amazon_fr_search_url(query)
    print(f"Opening: {url}")
    opened = webbrowser.open(url, new=2)
    if not opened:
        # Fallback message if the browser couldn't be opened
        print("Could not open the web browser automatically. Copy this URL into your browser:")
        print(url)


if __name__ == "__main__":
    main()


