zgrep 'Failed password for root' /var/log/auth.log*.gz  | awk -F ' ' '{print $11}' | sed '/Failed/d' > ./root_tries.txt

zgrep 'invalid user' /var/log/auth.log* | grep Failed | awk -F ' ' '{print $11,$13}' | awk '{print $2}' > ./only-ip.txt

while IFS= read -r line; #
        do newArr+=($line) #
done < only-ip.txt #

while IFS= read -r line;
        do newArr+=($line)
done < root_tries.txt


for i in "${newArr[@]}";do
        echo $i
done | sort | uniq -c | sort -nr > NUM_AND_IP.txt

while IFS= read -r line; do
	countArr+=($(echo $line | awk '{print $1}'))
	IPArr+=($(echo $line | awk '{print $2}'))
	countryArr+=($(geoiplookup `echo $line | awk '{print $2}'` | cut -d ' ' -f 5))
done < NUM_AND_IP.txt

echo "IP with most tries: ${IPArr[0]} with ${countArr[0]} requests."
echo "From `geoiplookup ${IPArr[0]} | cut -d ' ' -f 4-5`"

for ((i=0;i<${#IPArr[@]};i++)); do
	echo "${countArr[i]};${IPArr[i]};${countryArr[i]}"
done > output.txt

rm only-ip.txt
rm root_tries.txt
rm NUM_AND_IP.txt
python3 choroplat.py

rm output.txt
