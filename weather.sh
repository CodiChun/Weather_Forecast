#!/user/bin/bash

#check if the ip addres file exist
if [ -f ".myipaddr" ]; 
then 
    message="IP READ FROM CACHE"
    add=$(<.myipaddr)
else
    message="CALLING API TO QUERY MY IP"
    #Get the loc
    json="$(curl -u $TOKEN: ipinfo.io)"  
    add=$(echo $json|jq -r ."loc")
    echo "$add" > .myipaddr
fi

#split the loc string to string arr
arrIN=(${add//,/ })
lat=${arrIN[0]}  
lon=${arrIN[1]}  


#Generate the weather link
info="$(curl -s 'https://api.weatherbit.io/v2.0/forecast/daily?lat='$lat'&lon='$lon'&key=7062622be05d45a39e52ccab0d7bf8eb')"

#Print the 7 days weather forecast
echo "${message}"
echo "Forecast for my lat=${lat}°, lon=${lon}°"
for i in {0..6}
do
    date="$(echo $info | jq -r '.data['$i']."datetime"')"
    min="$(echo $info | jq -r '.data['$i']."app_min_temp"')"
    max="$(echo $info | jq -r '.data['$i']."app_max_temp"')"
    echo "Forecast for $date HI: ${max}°c LOW: ${min}°c"
done

