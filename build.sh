#! /usr/bin/env bash

../bidding_matcher/encryptlua.py
../bidding_matcher/buildver.py
cp ../bidding_matcher/matcher.ini ./
./goinstall public
./goinstall matchgo
./goinstall maintain