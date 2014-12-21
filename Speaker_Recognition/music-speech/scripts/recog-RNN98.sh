#!/bin/sh
#
# recog-RNN98.sh
#
# Run a BN recognition over the weird music/speech data
# 
# 1999feb23 dpwe@icsi.berkeley.edu
# $Header: $
#

# Set up defaults

UTTSET=musicspeech
NETTAG=RNN98

UTTSTART=0
UTTCOUNT=20

PHMODELS=/u/drspeech/data/bn/models/CI54_BN98.align3.model.ICSI
PRIORS=/u/drspeech/data/bn/models/CI54_BN98.align3.priors
TRIGRAM=/u/drspeech/data/bn/lm/bn97-65k-1-1.bin
DICT=/u/drspeech/data/bn/lex/aI1.dct
PMIN=0.00020
#NHYPS=7
#BEAM=2.0
#SBEAM=4.0
NHYPS=27
BEAM=5.0
SBEAM=6.0

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
	UTTSTART*)  UTTSTART=$ARG ;;
	UTTCOUNT*)  UTTCOUNT=$ARG ;;
	NHYPS*)     NHYPS=$ARG ;;
	BEAM*)      BEAM=$ARG ;;
	SBEAM*)     SBEAM=$ARG ;;
	PMIN*)      PMIN=$ARG ;;
	PHMODELS*)  PHMODELS=$ARG ;;
	PRIORS*)    PRIORS=$ARG ;;
	TRIGRAM*)   TRIGRAM=$ARG ;;
	DICT*)      DICT=$ARG ;;
	*) echo "$0: option $OPT unrecognized."
           echo "Usage: $0 [opt=val ...]  where opts are:"
	   echo " UTTSET  The utterance set basename ($UTTSET)"
	   echo " NETTAG  The network (acous model) tag ($NETTAG)"
	   echo " UTTSTART  The first utterance to process ($UTTSTART)"
	   echo " UTTCOUNT  The number of utterances to process ($UTTCOUNT)"
	   echo " NHYPS   The n_hyps pruning value for Noway ($NHYPS)"
	   echo " BEAM    The beam pruning value for Noway ($BEAM)"
	   echo " SBEAM   The state_beam pruning val for Noway ($SBEAM)"
	   echo " PMIN    The prob_min value to Noway ($PMIN)"
	   echo " PHMODELS  Noway phone models ($PHMODELS)"
	   echo " PRIORS    Noway priors file ($PRIORS)"
	   echo " TRIGRAM   Noway trigram ($TRIGRAM)"
	   echo " DICT      Noway dictionary ($DICT)"
	   exit 1;;
    esac
done


# Derived values

BASENAME=$UTTSET-$NETTAG
UTTEND=`expr $UTTCOUNT + $UTTSTART - 1`


RESULTSNAME=$BASENAME-$UTTSTART-$UTTEND.results
SCORENAME=$BASENAME-$UTTSTART-$UTTEND.score

feacat -ipf lna -opf lna -width 54 -sr $UTTSTART:$UTTEND $BASENAME.lna \
| noway-2.9 \
    -lna \
    -phone_models $PHMODELS \
    -priors $PRIORS \
    -trigram $TRIGRAM \
    -dictionary $DICT \
    -n_hyps $NHYPS \
    -beam $BEAM \
    -state_beam $SBEAM \
    -prob_min $PMIN \
    -new_lub \
    -acoustic_scale 0.3 \
    -reset_time_each_utt \
    -phone_deletion_penalty 1.4 \
    -smear_unigram \
> $RESULTSNAME

# Scoring
REFTMP=$BASENAME-$UTTSTART-$UTTEND.ref-tmp
head -`expr $UTTEND + 1` $UTTSET.ref | tail -$UTTCOUNT > $REFTMP
wordscore -v -r $REFTMP -w $RESULTSNAME > $SCORENAME
rm $REFTMP
