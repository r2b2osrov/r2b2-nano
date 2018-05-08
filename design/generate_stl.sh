rm ./stl/*.stl
for file in ./to_stl/*.scad; do
    filename=$(basename -- "$file")
    echo "Converting $(basename -- "$file") to ${filename%.*}.stl"
    openscad -o ./stl/${filename%.*}.stl $file
done
