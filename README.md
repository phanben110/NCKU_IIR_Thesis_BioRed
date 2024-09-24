# BioRED Relation Extraction (BioRED-RE)

-----

This repository provides the PubMedBERT version source code of our paper [BioRED: A Rich Biomedical Relation Extraction Dataset]. For the BERT-GT version, you can find it at [BERT-GT](https://github.com/ncbi/bert_gt)

## Environment:

* GPU: NVIDIA Tesla V100 SXM2
* Python: python3.9

## Set up:

```
conda create -n biored_re python=3.9
conda activate biored_re
pip install -r requirements.txt
```

## Step 1:

Because generating the input datasets is trivial (we have to install the scispacy), we provide our dataset_format_converter, and you can use it to convert the BioRED dataset into the input dataset of BioRED-RE.

### Download and generate the BioRED dataset for BioRED-RE
```
bash scripts/build_biored_dataset.sh
```

## Step 2:

BioRED-RE used [PubMedBERT]'s [pre-trained model](https://huggingface.co/microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract) because they support longer text (with 512 sequence length).

After downloading the model, please put the model (microsoft folder) in biored-re/.

## Step 3: Running on the BioRED dataset

```
bash run_biored_exp.sh <CUDA_VISIBLE_DEVICES>
```

Please replace the above <CUDA_VISIBLE_DEVICES> with your GPUs' IDs. Eg: '0,1' for GPU devices 0 and 1.
For example

```
bash run_biored_exp.sh 0,1
```

After finished, you should have below files:
* biored_pred_mul.txt: the prediction file in pubtator format.
* biored_mul_score.txt: the multi-class relation performance (in Table 6 of our paper).
* biored_mul_novelty_score.txt: the multi-class relation + novelty performance (in Table 6 of our paper).
* biored_bin_score.txt: the binary relation performance (in Table 6 of our paper).
* biored_bin_novelty_score.txt: the binary relation + novelty performance.

## Predicting New Data:

If you only wish to use our tool for predicting new data without the need for training, please follow the steps outlined below:

Download the [biored_re_model.tar](https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/biored_re_model.tar) file and place it in the "biored-re/" directory.

Open the "scripts/run_test_pred.sh" file and modify the values of the variables "in_pubtator_file" and "out_pubtator_file" to match your input PubTator file (with annotations) and the desired output PubTator file (where predicted relations will be stored).

Execute the following script to initiate the prediction process:

```
bash scripts/run_test_pred.sh <CUDA_VISIBLE_DEVICES>
```

Please replace the above <CUDA_VISIBLE_DEVICES> with your GPUs' IDs. Eg: '0,1' for GPU devices 0 and 1.
For example

```
bash scripts/run_test_pred.sh 0,1
```

## Citing BioRED

* Luo L., Lai P. T., Wei C. H., Arighi C. N. and Lu Z. BioRED: A Rich Biomedical Relation Extraction Dataset. Briefing in Bioinformatics. 2022.
```
@article{luo2022biored,
  author    = {Luo, Ling and Lai, Po-Ting and Wei, Chih-Hsuan and Arighi, Cecilia N and Lu, Zhiyong},
  title     = {BioRED: A Rich Biomedical Relation Extraction Dataset},
  journal   = {Briefing in Bioinformatics},
  year      = {2022},
  publisher = {Oxford University Press}
}
```

## Acknowledgments

The authors are grateful to Drs. Tyler F. Beck and Christine Colvis, Scientific Program Officer at the NCATS and their entire research team for help with our dataset. The authors would like to thank Rancho BioSciences and specifically, Mica Smith, Thomas Allen Ford-Hutchinson, and Brad Farrell for their contribution with data curation.

## Disclaimer

This tool shows the results of research conducted in the Computational Biology Branch, NCBI. The information produced
on this website is not intended for direct diagnostic use or medical decision-making without review and oversight
by a clinical professional. Individuals should not change their health behavior solely on the basis of information
produced on this website. NIH does not independently verify the validity or utility of the information produced
by this tool. If you have questions about the information produced on this website, please see a health care
professional. More information about NCBI's disclaimer policy is available.
# NCKU_IIR_Thesis_BioRed
