#!/bin/sh
#
# recog-chronos.sh
#
# Run a BN recognition over the weird music/speech data, using chronos
# 
# 1999feb23 dpwe@icsi.berkeley.edu
# $Header: /n/yam/da/dpwe/projects/uttclass/malcolm-music-speech/recog-chronos.sh,v 1.2 1999/03/01 05:38:11 dpwe Exp dpwe $
#

# Set up defaults

UTTSET=musicspeech
NETTAG=RNN98

UTTRANGE=
TAG=test-speech

PHI=/u/drspeech/data/bn/models/CI54_BN98.align3.phi
TRIGRAM=/u/drspeech/data/bn/lm/bn97-65k-1-1.bin
#DICT=/u/drspeech/data/bn/lex/bn96-65k.dct
DICT=aI1-musicspeech.dct
PMIN=0.0020
NHYPS=8191
BEAM=5.0
CHRONOS=chronos
GAMMA=1.0
ASCALE=0.35
PSCALE=0.9

# Use command line args
for OPT in $* ; do 
    # Isolate opt arg
    case "$OPT" in
      *=*) ARG=`echo "$OPT" | sed 's/[-_a-zA-Z0-9]*=//'` ;;
      *) ARG= ;;
    esac
    # Set parameters
    case "$OPT" in 
	UTTSET*)    UTTSET=$ARG ;;
        NETTAG*)    NETTAG=$ARG ;;
	UTTRANGE*)  UTTRANGE=$ARG ;;
	TAG*)       TAG=$ARG ;;
	NHYPS*)     NHYPS=$ARG ;;
	BEAM*)      BEAM=$ARG ;;
	PMIN*)      PMIN=$ARG ;;
	PHI*)       PHI=$ARG ;;
	TRIGRAM*)   TRIGRAM=$ARG ;;
	DICT*)      DICT=$ARG ;;
        CHRONOS*)   CHRONOS=$ARG ;;
	GAMMA*)     GAMMA=$ARG ;;
	PSCALE*)    PSCALE=$ARG ;;
	ASCALE*)    ASCALE=$ARG ;;
	*) echo "$0: option $OPT unrecognized."
           echo "Usage: $0 [opt=val ...]  where opts are:"
	   echo " UTTSET  The utterance set basename ($UTTSET)"
	   echo " NETTAG  The network (acous model) tag ($NETTAG)"
	   echo " UTTRANGE  A Range(3) string saying which utts to process ($UTTRANGE or guess from TAG and ./RANGES)"
	   echo " TAG     A tag to put on output files designating which utts ($TAG)"
	   echo " NHYPS   The n_hyps pruning value for Noway ($NHYPS)"
	   echo " BEAM    The beam pruning value for Noway ($BEAM)"
	   echo " PMIN    The prob_min value to Noway ($PMIN)"
	   echo " PHI       Chronos phone models/prios ($PHI)"
	   echo " TRIGRAM   Chronos trigram ($TRIGRAM)"
	   echo " DICT      Chronos dictionary ($DICT)"
	   echo " CHRONOS   Chronos binary ($CHRONOS)"
	   echo " GAMMA     Chronos gamma ($GAMMA)"
	   echo " PSCALE    Chronos pmScale ($PSCALE)"
	   echo " ASCALE    Chronos amScale ($ASCALE)"
	   exit 1;;
    esac
done


# Derived values

BASENAME=$UTTSET-$NETTAG

RESULTSNAME=$BASENAME-$TAG.results
SCORENAME=$BASENAME-$TAG.score

# File mapping tags to subset ranges
RANGEDEFFILE=./RANGES

if [ -z "$UTTRANGE" ]; then
    # Rangedef is second token in that line of the rangedeffile
    UTTRANGE=`egrep "^$TAG[ 	]" $RANGEDEFFILE | sed "s/[^ 	]*[ 	][ 	]*//"`
fi

feacat -ipf lna -opf lna -width 54 -sr $UTTRANGE $BASENAME.lna \
| $CHRONOS \
    -phi $PHI \
    -lm $TRIGRAM \
    -dct $DICT \
    -nhyp $NHYPS \
    -beamWidth $BEAM \
    -probMin $PMIN \
    -amScale $ASCALE \
    -pmScale $PSCALE \
    -gamma $GAMMA \
> $RESULTSNAME

# Scoring
REFTMP=$BASENAME-$TAG.ref-tmp
linecat -r $UTTRANGE $UTTSET.ref > $REFTMP
wordscore -b % -m % -e % -v -r $REFTMP -w $RESULTSNAME > $SCORENAME
rm $REFTMP
