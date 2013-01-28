#!/bin/bash
#формат вызова : ./cli_task3.sh log_file yyyy-mm-dd

if [ $# -ne 2 ] #если длина массива параметров не равна 2
then
  echo "Usage help : ./cli_task3.sh log_file_path date_in_format_\"yyyy-mm-dd\" \n Example : ./cli_task3.sh ./logs.txt 2013-01-01"
  exit 0
fi

if ! [[ $2 =~ ^[\-0-9]+$ ]]
then
	echo "Формат ввода дня : 2012-01-01"
	exit 0
fi

query_processing_times=($(grep "$2 12:.*/resume.* 200 .*" $1 | sed "s|.* 200 \(.*\)ms|\1|" | sort -n))

total_processing_time=0.0
for t in "${query_processing_times[@]}"
do
	total_processing_time=$(echo $total_processing_time + $t | bc)
done

echo "Общее время обработки успешных запросов : $total_processing_time ms"
echo "95-квантиль для времени обработки запросов :  ${query_processing_times[$((${#query_processing_times[@]}*95/100))]}"
echo "95-квантиль для времени обработки запросов :  ${query_processing_times[$((${#query_processing_times[@]}*99/100))]}"
echo "Медиана : ${query_processing_times[$((${#query_processing_times[@]}/2))]}"

echo

resume_processing_times=($(grep "$2 .*/resume.*id=43.* 200 .*" $1 | sed "s|.* 200 \(.*\)ms|\1|" | sort -n))

total_resume_processing_time=0.0
for time in "${resume_processing_times[@]}"
do
	total_resume_processing_time=$(echo $total_resume_processing_time + $time | bc)
done

echo "Среднее время обработки запроса для резюме с id=43 : $(echo $total_resume_processing_time / ${#resume_processing_times[@]} | bc)"
echo "Медиана времени обработки запроса для резюме с id=43 : $(echo $total_resume_processing_time / 2 | bc)"

