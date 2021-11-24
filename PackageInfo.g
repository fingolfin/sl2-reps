#
# SL2Reps: Constructs representations of SL2(Z).
#
# This file contains package meta data. For additional information on
# the meaning and correct usage of these fields, please consult the
# manual of the "Example" package as well as the comments in its
# PackageInfo.g file.
#
SetPackageInfo( rec(

PackageName := "SL2Reps",
Subtitle := "Constructs representations of SL2(Z).",
Version := "0.1",
Date := "24/09/2021", # dd/mm/yyyy format
License := "GPL-2.0-or-later",

Persons := [
  rec(
    FirstNames := "Siu-Hung",
    LastName := "Ng",
    #WWWHome := TODO,
    Email := "rng@math.lsu.edu",
    IsAuthor := true,
    IsMaintainer := false,
    #PostalAddress := TODO,
    Place := "Baton Rouge, LA, USA",
    Institution := "Louisiana State University",
  ),
  rec(
    FirstNames := "Yilong",
    LastName := "Wang",
    #WWWHome := TODO,
    Email := "wyl@bimsa.cn",
    IsAuthor := true,
    IsMaintainer := false,
    #PostalAddress := TODO,
    #Place := TODO,
    Institution := "Yanqi Lake Beijing Institute of Mathematical Sciences and Applications",
  ),
  rec(
    FirstNames := "Samuel",
    LastName := "Wilson",
    #WWWHome := TODO,
    Email := "swil311@lsu.edu",
    IsAuthor := true,
    IsMaintainer := true,
    #PostalAddress := TODO,
    Place := "Baton Rouge, LA, USA",
    Institution := "Louisiana State University",
  ),
],

#SourceRepository := rec( Type := "TODO", URL := "URL" ),
#IssueTrackerURL := "TODO",
PackageWWWHome := "https://github.com/ontoclasm/sl2-reps",
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),
README_URL     := Concatenation( ~.PackageWWWHome, "README.md" ),
ArchiveURL     := Concatenation( ~.PackageWWWHome,
                                 "/", ~.PackageName, "-", ~.Version ),

ArchiveFormats := ".tar.gz",

##  Status information. Currently the following cases are recognized:
##    "accepted"      for successfully refereed packages
##    "submitted"     for packages submitted for the refereeing
##    "deposited"     for packages for which the GAP developers agreed
##                    to distribute them with the core GAP system
##    "dev"           for development versions of packages
##    "other"         for all other packages
##
Status := "dev",

AbstractHTML   :=  "",

PackageDoc := rec(
  BookName  := "SL2Reps",
  ArchiveURLSubset := ["doc"],
  HTMLStart := "doc/chap0.html",
  PDFFile   := "doc/manual.pdf",
  SixFile   := "doc/manual.six",
  LongTitle := "Constructs representations of SL2(Z).",
),

Dependencies := rec(
  GAP := ">= 4.11",
  NeededOtherPackages := [ ],
  SuggestedOtherPackages := [ ],
  ExternalConditions := [ ],
),

AvailabilityTest := ReturnTrue,

TestFile := "tst/testall.g",

#Keywords := [ "TODO" ],

));


