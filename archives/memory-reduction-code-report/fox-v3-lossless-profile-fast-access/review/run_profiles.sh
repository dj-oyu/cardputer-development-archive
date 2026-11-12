#!/bin/bash
set -eu
cd /workspace/scratch/6d8dcdbcdc54
r=fox-v3-lossless-profile-fast-access/review
i=fox-v3-lossless-profile-fast-access/implementation
p=fox-v3-lossless-profile-lut/profile
flags='-O2 -fno-fast-math -ffp-contract=off'
gcc $flags -Dagx_profile_eval=old_eval -c fox-v3-profile-integration-feasibility/build-private/agx_profile.c -o $r/old.o
for arm in fast gather both; do
 b=1; g=1; if [ "$arm" = fast ]; then g=0; fi; if [ "$arm" = gather ]; then b=0; fi
 gcc $flags -DFAST_BITS=$b -c $i/block_decoder.c -o $r/decoder_$arm.o
 gcc $flags -DGATHER=$g -Dagx_profile_eval=new_eval -I$p -I$p/private -c $i/candidate_profile.c -o $r/profile_$arm.o
 gcc $flags $r/profile_replay.c $r/old.o $r/decoder_$arm.o $r/profile_$arm.o -lm -o $r/replay_$arm
 $r/replay_$arm f32 $p/private/all_inputs.f32le > $r/profile_$arm.log
done
