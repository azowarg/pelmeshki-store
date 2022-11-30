pictures_urls=(
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932687/repos/momos/8dee5a92281746aa887d6f19cf9fdcc7.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932687/repos/momos/50b583271fa0409fb3d8ffc5872e99bb.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/8b50f76f514a4ccaaacdcb832a1b3a2f.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/788c073d83c14b3fa00675306dfb32b5.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/32cc88a33c3243a6a8838c034878c564.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/7685ad7e9e634a58a4c29120ac5a5ee1.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/4bdaeab0ee1842dc888d87d4a435afdd.jpg"
    "https://res.cloudinary.com/sugrobov/image/upload/v1651932686/repos/momos/f64dcea998e34278a0006e0a2b104710.jpg"
)

mkdir pictures

for url in "${pictures_urls[@]}"
do
    curl $url -o "pictures/${url#*momos/}" -s
done
