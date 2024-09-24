#!/bin/bash

echo 'Downloading the dataset'
curl -k -o BIORED.zip https://ftp.ncbi.nlm.nih.gov/pub/lu/BioRED/BIORED.zip
echo 'Unzip the dataset'
mkdir -p datasets/biored
unzip BIORED.zip -d datasets/biored
rm BIORED.zip
echo 'Converting the dataset into BioRED-RE input format'
python src/dataset_format_converter/convert_pubtator_2_bert.py
