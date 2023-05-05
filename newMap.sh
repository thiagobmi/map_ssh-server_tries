cat /var/log/auth.log* | grep 'Failed password for root' | awk -F ' ' '{print $11}' | sed '/Failed/d' > ./root_tries.txt

cat /var/log/auth.log* | grep Failed | grep 'invalid user' | awk -F ' ' '{print $11,$13}' | awk '{print $2}' > only-ip.txt

while IFS= read -r line; #
        do newArr+=($line) #
done < only-ip.txt #

while IFS= read -r line;
        do newArr+=($line)
done < root_tries.txt


for i in "${newArr[@]}"; do
        echo "`geoiplookup $i | cut -d ' ' -f 5`"
done | sort | uniq -c | sort -nr > output.txt

rm only-ip.txt
rm root_tries.txt

python3 choroplat.py

rm output.txt