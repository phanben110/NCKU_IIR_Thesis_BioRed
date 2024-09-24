#!/bin/bash

cuda_visible_devices=$1

task_names=('biored_all_mul' 'biored_novelty')
# task_names=('biored_novelty')

pre_trained_model="/home/iir/work/ben/NCKU/IIR/BioRed/out_model_public_data_v3_biored_all_mul"


for task_name in ${task_names[*]}
do
    in_data_dir='/home/iir/work/ben/NCKU/IIR/BioRed/datasets/biored/processed_2'
    entity_num=2
    no_neg_for_train_dev=false

    if [[ $task_name =~ "novelty" ]]
    then
        no_neg_for_train_dev=true
        pre_trained_model="/home/iir/work/ben/NCKU/IIR/BioRed/out_model_public_data_v3_biored_novelty"
    fi

    cuda_visible_devices=$cuda_visible_devices python src/run_biored_exp.py \
      --task_name $task_name \
      --train_file $in_data_dir/train.tsv \
      --dev_file /home/iir/work/ben/NCKU/IIR/BioRed/datasets/biored/processed/dev.tsv \
      --test_file /home/iir/work/ben/NCKU/IIR/BioRed/datasets/biored/processed/test.tsv \
      --use_balanced_neg false \
      --to_add_tag_as_special_token true \
      --no_neg_for_train_dev $no_neg_for_train_dev \
      --model_name_or_path "${pre_trained_model}" \
      --output_dir out_model_public_data_original_v0_${task_name} \
      --num_train_epochs 10 \
      --learning_rate 1e-5 \
      --per_device_train_batch_size 10 \
      --per_device_eval_batch_size 10 \
      --do_train \
      --do_predict \
      --logging_steps 1 \
      --evaluation_strategy steps \
      --save_steps 1 \
      --overwrite_output_dir \
      --max_seq_length 512
    cp out_model_${task_name}/test_results.tsv out_${task_name}_test_results.tsv
done

# python src/utils/run_biored_eval.py --exp_option 'to_pubtator' \
#     --in_pred_rel_tsv_file "out_biored_all_mul_test_results.tsv" \
#     --in_pred_novelty_tsv_file "out_biored_novelty_test_results.tsv" \
#     --out_pred_pubtator_file "biored_pred_mul.txt"

# python src/utils/run_biored_eval.py --exp_option 'biored_eval' \
#     --in_gold_pubtator_file "/home/iir/work/ben/NCKU/IIR/BioRed/datas/Bio_Competition_dataset/test/Test.PubTator" \
#     --in_pred_pubtator_file "biored_pred_mul.txt"
