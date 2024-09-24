#!/bin/bash

in_pubtator_file="datas/Bio_Competition_dataset/Test.PubTator"
out_tsv_file="tmp/out_processed.tsv"
out_pubtator_file="tmp/predict_v7.pubtator"

echo 'Converting the dataset into BioRED-RE input format'
# python src/dataset_format_converter/convert_pubtator_2_bert.py \
#     --in_pubtator_file ${in_pubtator_file} \
#     --out_tsv_file ${out_tsv_file}

cuda_visible_devices=$1

task_names=('biored_all_mul' 'biored_novelty')
# task_names=('biored_all_mul' )

pre_trained_model="/home/iir/work/ben/NCKU/IIR/BioRed/out_model_public_data_v7_biored_all_mul"

echo 'Generating RE and novelty predictions'
for task_name in ${task_names[*]}
do
    in_data_dir='datasets/biored/processed'
    entity_num=2
    no_neg_for_train_dev=false

    if [[ $task_name =~ "novelty" ]]
    then
        pre_trained_model="/home/iir/work/ben/NCKU/IIR/BioRed/out_model_public_data_v7_biored_novelty"
    fi

    cuda_visible_devices=$cuda_visible_devices python src/run_biored_exp.py \
      --task_name $task_name \
      --test_file ${out_tsv_file} \
      --use_balanced_neg false \
      --to_add_tag_as_special_token true \
      --model_name_or_path "${pre_trained_model}" \
      --output_dir out_model_${task_name} \
      --num_train_epochs 2 \
      --learning_rate 1e-5 \
      --per_device_train_batch_size 20 \
      --per_device_eval_batch_size 20 \
      --do_predict \
      --logging_steps 1 \
      --evaluation_strategy steps \
      --save_steps 1 \
      --overwrite_output_dir \
      --max_seq_length 512
    cp out_model_${task_name}/test_results.tsv out_${task_name}_test_results.tsv
done

echo 'Generating PubTator file'
python src/utils/run_biored_eval.py --exp_option 'to_pubtator' \
    --in_test_pubtator_file ${in_pubtator_file} \
    --in_test_tsv_file ${out_tsv_file} \
    --in_pred_rel_tsv_file "out_biored_all_mul_test_results.tsv" \
    --in_pred_novelty_tsv_file "out_biored_novelty_test_results.tsv" \
    --out_pred_pubtator_file ${out_pubtator_file}
