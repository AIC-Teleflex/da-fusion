#!/bin/bash
#SBATCH --job-name=spurge
#SBATCH --exclude=matrix-1-12,matrix-0-24,matrix-1-4,matrix-2-13,matrix-1-8
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --partition=russ_reserved
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-gpu=8
#SBATCH --mem=32g
#SBATCH --array=0-39
 
source ~/anaconda3/etc/profile.d/conda.sh
conda activate semantic-aug
cd ~/spurge/semantic-aug

RANK=$SLURM_ARRAY_TASK_ID WORLD_SIZE=$SLURM_ARRAY_TASK_COUNT \
python train_classifier.py --dataset pascal \
--logdir pascal-baselines/textual-inversion-0.5 \
--synthetic-dir "/projects/rsalakhugroup/btrabucc/aug/\
textual-inversion-0.5/{dataset}-{seed}-{examples_per_class}" \
--aug textual-inversion --prompt "a photo of a {name}" \
--strength 0.5 --num-synthetic 10 \
--synthetic-probability 0.5 --num-trials 8 \
--examples-per-class 1 2 4 8 16