   #!/bin/bash

   # Boucle sur chaque mois de janvier à août
   for month in {1..8}
   do
       # Définir le nombre de jours dans chaque mois
       if [ "$month" -eq 2 ]; then
           days=28  # Février (non bissextile)
       elif [[ "$month" -eq 4 || "$month" -eq 6 || "$month" -eq 9 || "$month" -eq 11 ]]; then
           days=30  # Avril, Juin, Septembre, Novembre
       else
           days=31  # Janvier, Mars, Mai, Juillet, Août
       fi

       # Créer un tableau pour les jours du mois
       days_array=($(seq 1 $days))

       # Créer un tableau pour stocker les jours avec des commits multiples
       days_with_commits=()

       # Générer 25 commits
       for i in {1..25}
       do
           # Choisir un jour aléatoire
           day=$(shuf -e "${days_array[@]}" | head -n 1)

           # Si le jour a déjà des commits, choisir un nombre aléatoire de commits (9 à 15)
           if [[ " ${days_with_commits[@]} " =~ " $day " ]]; then
               num_commits=$(shuf -i 9-15 -n 1)
           else
               num_commits=$(shuf -i 1-5 -n 1)  # Pour les premiers commits, 1 à 5
               days_with_commits+=("$day")
           fi

           # Créer les commits
           for ((j=0; j<num_commits; j++))
           do
               # Créer une date formatée
               date=$(printf "2025-%02d-%02d" "$month" "$day")

               # Créer un fichier avec la date
               echo "Commit pour le $date (partie $((j+1)))" > "fichier_${month}_${day}_${j}.txt"
               git add "fichier__${month}_${day}_${j}.txt"

               # Faire le commit avec la date spécifiée
               git commit -m "Commit du $date (partie $((j+1)))" --date="$date"
           done

           # Retirer le jour utilisé de l'array pour éviter les répétitions
           days_array=("${days_array[@]/$day}")
       done
   done

