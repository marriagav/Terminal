#!/usr/bin/env python

import sys
from datetime import datetime, timezone

import dateparser


def main():
    # Check if input is provided
    if len(sys.argv) < 1:
        print("Please provide a date string as input")
        sys.exit(1)

    # Join all command line arguments into a single string
    nlp_date = str(sys.argv[1:])

    # Parse the NLP date using dateparser
    parsed_date = dateparser.parse(
        nlp_date, settings={"RETURN_AS_TIMEZONE_AWARE": True}
    )

    if parsed_date:
        # Convert to UTC timezone
        utc_date = parsed_date.astimezone(timezone.utc)
        # Format the date as desired
        due_date = utc_date.strftime("%Y-%m-%dT%H:%M:%SZ")
        # Print the output
        print(due_date)
    else:
        print("Failed to parse the date")


if __name__ == "__main__":
    main()
