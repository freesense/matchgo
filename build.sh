#! /usr/bin/env bash

../bidding_matcher/encryptlua.py
../bidding_matcher/buildver.py
./goinstall public
./goinstall matchgo
./goinstall maintain