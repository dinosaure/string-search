(* Romain Calascibetta - @Dinoosaure *)

(* Décale une liste: [1;2;3] -> [2;3;1] *)

let rotone l = 
  let rec rotone_ l acc = match l with
    | [] -> (List.rev acc)
    | [x] -> x :: (List.rev acc)
    | x :: r -> rotone_ r (x :: acc)
  in rotone_ l [];;

(* Génère une représentation BWT d'une liste de caractères *)

let bwt l =
  let rec bwt_ l acc n = match acc, n with
    | _, 0 -> acc
    | [], _ -> bwt_ l [(n - 1, rotone l)] (n - 1)
    | x :: r, n -> bwt_ l ((n - 1, rotone (snd x)) :: acc) (n - 1) in
  bwt_ l [] (List.length l);;

(* Merge sort with continuation programming *)

let rec odd k = function
  | [] -> k []
  | [a] -> k []
  | a :: b :: c -> odd (fun x -> k (b :: x)) c;;

let even k = function
  | [] -> k []
  | x :: r -> x :: odd k r;;

let rec merge a b cmp k = match a, b with
  | [], _ -> k b
  | _, [] -> k a
  | xa :: ra, xb :: rb -> if cmp xa xb > 0
                          then merge ra b cmp (fun x -> k (xa :: x))
                          else merge a rb cmp (fun x -> k (xb :: x));;

let id x = x;;

let rec sort l cmp k = match l with
  | [] -> k []
  | [a] -> k [a]
  | _ -> let p = even id l in
         let q = odd id l in
           sort p cmp (fun x -> 
             sort q cmp (fun y -> merge x y cmp k));;

(* Transforme une liste de caractères en une chaîne *)

let implode l =
  let s = String.create (List.length l) in
  let rec f n = function
    | x :: xs -> s.[n] <- x; f (n + 1) xs
    | [] -> s
  in f 0 l

(* Transforme une chaîne de caractère en une liste *)

let explode s =
  let rec f acc = function
    | -1 -> acc
    | k -> f (s.[k] :: acc) (k - 1)
  in f [] (String.length s - 1);;

let compare a b = String.compare (implode (snd b)) (implode (snd a));;

let lower l = List.map (fun x -> x - 1) l;;
let upper l = List.map (fun x -> x + 1) l;;

(* 
 * Chercher les premiers rangs
 * dès que le premier caractère de la chaîne courante équivaut à c,
 * on rajoute son rang dans le résultat
*)

let rec first_search c bwt acc = match bwt with
    | [] -> acc
    | x :: r -> if (List.hd (snd x)) == c then first_search c r ((fst x) :: acc)
                else first_search c r acc;;

(* 
 * Vérifier les rangs suivants
 * on regarde si le rang qu'on nous propose contient bien le caractère c 
 * si c'est le cas, on l'ajoute au résultat
*)

let rec last_search c bwt l acc = 
  let rec compare bwt i c = match bwt with 
    | [] -> false
    | x :: r -> if (fst x) == i && (List.hd (snd x)) == c then true
                else compare r i c in
  match l with
    | [] -> acc
    | x :: r -> if (x >= 0 && compare bwt x c) then last_search c bwt r (x :: acc)
                else last_search c bwt r acc;;

(* Cherche une occurrence dans une chaîne 
 * on génère une premiere liste de rangs avec first_search
 * on baisse d'un indice tout les rangs du résultat
 * on génère une nouvelle liste de rangs avec last_search
 * on repète l'action 2 et 3 tant que la sous-chaîne n'est pas consummer
*)

let rec search a b =
  let a = List.rev (explode a) in
  let b = explode b in
  let bwt = sort (bwt b) compare id in
  let rec search_ s len bwt l = match s with
    | [] -> upper l
    | x :: r -> let ranks = if len == 0
                            then (first_search x bwt l)
                            else (last_search x bwt l [])
                in search_ r (len + 1) bwt (lower ranks)
  in search_ a 0 bwt [];;

(* Affiche le résultat *)

let rec display l str = 
  let rec display_ = function
    | 0 -> Printf.printf "^\n"
    | n -> Printf.printf " "; display_ (n - 1) in
  match l with
  | [] -> ()
  | x :: r -> Printf.printf "%s\n" str; display_ x; display r str;;

let _ = if Array.length Sys.argv == 3
        then  let l = search (Array.get Sys.argv 1) (Array.get Sys.argv 2) in 
              display (sort l (fun a -> fun b -> b - a) id) (Array.get Sys.argv 2)
        else Printf.printf "%s string template\n" (Array.get Sys.argv 0)
