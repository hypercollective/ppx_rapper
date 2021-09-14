type a = { username: string }

type b = { id: int; username: string }

type c = { id: int; username: string; email: string }

let many_arg_execute =
  let query =
    (let open Caqti_request in
    exec)
      ((let open Caqti_type in
       tup2 string (tup2 string (tup2 (option string) int)))
      [@ocaml.warning "-33"])
      "\n\
      \      UPDATE users\n\
      \      SET (username, email, bio) = (?, ?, ?)\n\
      \      WHERE id = ?\n\
      \      "
  in
  let wrapped ~username ~email ~bio ~id (module Db : Rapper_helper.CONNECTION) =
    Db.exec query (username, (email, (bio, id)))
  in
  wrapped

let single_arg_execute =
  let query =
    (let open Caqti_request in
    exec)
      ((let open Caqti_type in
       string) [@ocaml.warning "-33"])
      "\n      UPDATE users\n      SET username = ?\n      "
  in
  let wrapped ~username (module Db : Rapper_helper.CONNECTION) =
    Db.exec query username
  in
  wrapped

let no_arg_execute =
  let query =
    (let open Caqti_request in
    exec)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      "\n      UPDATE users\n      SET username = 'Hello!'\n      "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) = Db.exec query () in
  wrapped

let many_arg_get_one =
  let query =
    (let open Caqti_request in
    find)
      ((let open Caqti_type in
       tup2 string int) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int (tup2 string (tup2 (option string) bool)))
      [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username, bio, is_married\n\
      \      FROM users\n\
      \      WHERE username = ? AND id > ?\n\
      \      "
  in
  let wrapped ~username ~min_id (module Db : Rapper_helper.CONNECTION) =
    let f result =
      match result with
      | Ok (id, (username, (bio, is_married))) ->
          Ok (id, username, bio, is_married)
      | Error e -> Error e
    in
    Rapper_helper.map f (Db.find query (username, min_id))
  in
  wrapped

let single_arg_get_one =
  let query =
    (let open Caqti_request in
    find)
      ((let open Caqti_type in
       string) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username\n\
      \      FROM users\n\
      \      WHERE username = ?\n\
      \      "
  in
  let wrapped ~username (module Db : Rapper_helper.CONNECTION) =
    let f result =
      match result with
      | Ok (id, username) -> Ok { id; username }
      | Error e -> Error e
    in
    Rapper_helper.map f (Db.find query username)
  in
  wrapped

let no_arg_get_one =
  let query =
    (let open Caqti_request in
    find)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int (tup2 string string)) [@ocaml.warning "-33"])
      "\n      SELECT id, username, email\n      FROM users\n      "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      match result with
      | Ok (id, (username, email)) -> Ok { id; username; email }
      | Error e -> Error e
    in
    Rapper_helper.map f (Db.find query ())
  in
  wrapped

let many_arg_get_one_repeated_arg =
  let query =
    (let open Caqti_request in
    find)
      ((let open Caqti_type in
       tup2 int (tup2 string int)) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT username\n\
      \      FROM users\n\
      \      WHERE id = ? OR username = ? OR id <> ?\n\
      \      "
  in
  let wrapped ~id ~username (module Db : Rapper_helper.CONNECTION) =
    let f result =
      match result with Ok username -> Ok { username } | Error e -> Error e
    in
    Rapper_helper.map f (Db.find query (id, (username, id)))
  in
  wrapped

let many_arg_get_opt =
  let query =
    (let open Caqti_request in
    find_opt)
      ((let open Caqti_type in
       tup2 string int) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username\n\
      \      FROM users\n\
      \      WHERE username = ? AND id > ?\n\
      \      "
  in
  let wrapped ~username ~min_id (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = (id, username) in
      let f =
        (fun f x -> match x with Some x -> Some (f x) | None -> None) g
      in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.find_opt query (username, min_id))
  in
  wrapped

let single_arg_get_opt =
  let query =
    (let open Caqti_request in
    find_opt)
      ((let open Caqti_type in
       string) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username\n\
      \      FROM users\n\
      \      WHERE username = ?\n\
      \      "
  in
  let wrapped ~username (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = { id; username } in
      let f =
        (fun f x -> match x with Some x -> Some (f x) | None -> None) g
      in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.find_opt query username)
  in
  wrapped

let no_arg_get_opt =
  let query =
    (let open Caqti_request in
    find_opt)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n      SELECT id, username\n      FROM users\n      "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = (id, username) in
      let f =
        (fun f x -> match x with Some x -> Some (f x) | None -> None) g
      in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.find_opt query ())
  in
  wrapped

let many_arg_get_many =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       tup2 string int) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username\n\
      \      FROM users\n\
      \      WHERE username = ? AND id > ?\n\
      \      "
  in
  let wrapped ~username ~min_id (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = { id; username } in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query (username, min_id))
  in
  wrapped

let single_arg_get_many =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       string) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username\n\
      \      FROM users\n\
      \      WHERE username = ?\n\
      \      "
  in
  let wrapped ~username (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = (id, username) in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query username)
  in
  wrapped

let no_arg_get_many =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n      SELECT id, username\n      FROM users\n      "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, username) = { id; username } in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query ())
  in
  wrapped

let my_query =
  let query =
    (let open Caqti_request in
    find_opt)
      ((let open Caqti_type in
       tup2 string int) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int (tup2 string (tup2 bool (option string))))
      [@ocaml.warning "-33"])
      "\n\
      \      SELECT id, username, following, bio\n\
      \      FROM users\n\
      \      WHERE username <> ? AND id > ?\n\
      \      "
  in
  let wrapped ~wrong_user ~min_id (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, (username, (following, bio))) =
        (id, username, following, bio)
      in
      let f =
        (fun f x -> match x with Some x -> Some (f x) | None -> None) g
      in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.find_opt query (wrong_user, min_id))
  in
  wrapped

let list =
  let wrapped ~following ~ids (module Db : Rapper_helper.CONNECTION) =
    match ids with
    | [] ->
        Rapper_helper.fail
          (let open Caqti_error in
          encode_rejected ~uri:Uri.empty ~typ:Caqti_type.unit (Msg "Empty list"))
    | elems ->
        let subsqls = Stdlib.List.map (fun _ -> "?") elems in
        let patch = Stdlib.String.concat ", " subsqls in
        let sql =
          "\n\
          \      SELECT id, username, following, bio\n\
          \      FROM users\n\
          \      WHERE following = ? and username IN (" ^ patch ^ ")\n      "
        in
        let open Rapper.Internal in
        let (Dynparam.Pack (packed_list_type, ids)) =
          Stdlib.List.fold_left
            (fun pack item ->
              Dynparam.add
                ((let open Caqti_type in
                 int) [@ocaml.warning "-33"])
                item pack)
            Dynparam.empty elems
        in
        let query =
          (let open Caqti_request in
          find_opt)
            ~oneshot:true
            (let open Caqti_type in
            tup2 bool packed_list_type)
            ((let open Caqti_type in
             tup2 int (tup2 string (tup2 bool (option string))))
            [@ocaml.warning "-33"])
            sql
        in
        let f result =
          let g (id, (username, (following, bio))) =
            (id, username, following, bio)
          in
          let f =
            (fun f x -> match x with Some x -> Some (f x) | None -> None) g
          in
          match result with Ok x -> Ok (f x) | Error e -> Error e
        in
        Rapper_helper.map f (Db.find_opt query (following, ids))
  in
  wrapped

let collect_list =
  let wrapped ~versions (module Db : Rapper_helper.CONNECTION) =
    match versions with
    | [] ->
        Rapper_helper.fail
          (let open Caqti_error in
          encode_rejected ~uri:Uri.empty ~typ:Caqti_type.unit (Msg "Empty list"))
    | elems ->
        let subsqls = Stdlib.List.map (fun _ -> "?") elems in
        let patch = Stdlib.String.concat ", " subsqls in
        let sql =
          " SELECT id from schema_migrations where version in (" ^ patch ^ ")"
        in
        let open Rapper.Internal in
        let (Dynparam.Pack (packed_list_type, versions)) =
          Stdlib.List.fold_left
            (fun pack item ->
              Dynparam.add
                ((let open Caqti_type in
                 int) [@ocaml.warning "-33"])
                item pack)
            Dynparam.empty elems
        in
        let query =
          (let open Caqti_request in
          collect)
            ~oneshot:true packed_list_type
            ((let open Caqti_type in
             string) [@ocaml.warning "-33"])
            sql
        in
        Db.collect_list query versions
  in
  wrapped

module Suit : Ppx_rapper_runtime.CUSTOM = struct
  type t = Clubs | Diamonds | Hearts | Spades

  let t =
    let encode = function
      | Clubs -> Ok "c"
      | Diamonds -> Ok "d"
      | Hearts -> Ok "h"
      | Spades -> Ok "s"
    in
    let decode = function
      | "c" -> Ok Clubs
      | "d" -> Ok Diamonds
      | "h" -> Ok Hearts
      | "s" -> Ok Spades
      | _ -> Error "invalid suit"
    in
    let open Caqti_type in
    custom ~encode ~decode string
end

let get_cards =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       Suit.t) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int Suit.t) [@ocaml.warning "-33"])
      " SELECT id, suit FROM cards WHERE suit <> ? "
  in
  let wrapped ~suit (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, suit) = (id, suit) in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query suit)
  in
  wrapped

let all_types =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 string
         (tup2 octets
            (tup2 int
               (tup2 int32
                  (tup2 int64
                     (tup2 bool
                        (tup2 float
                           (tup2 pdate
                              (tup2 ptime
                                 (tup2 ptime_span
                                    (tup2 Caqti_type_calendar.cdate
                                       Caqti_type_calendar.ctime)))))))))))
      [@ocaml.warning "-33"])
      " SELECT id, payload, version,\n\
      \                some_int32, some_int64, added,\n\
      \                fl, date, time, span,\n\
      \                cd, ct\n\
      \         FROM some_table "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g
          ( id,
            ( payload,
              ( version,
                ( some_int32,
                  (some_int64, (added, (fl, (date, (time, (span, (cd, ct)))))))
                ) ) ) ) =
        ( id,
          payload,
          version,
          some_int32,
          some_int64,
          added,
          fl,
          date,
          time,
          span,
          cd,
          ct )
      in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query ())
  in
  wrapped

module Nested = struct
  module Suit = Suit
end

let get_cards =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       Nested.Suit.t) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int Nested.Suit.t) [@ocaml.warning "-33"])
      " SELECT id, suit FROM cards WHERE suit <> ? "
  in
  let wrapped ~suit (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, suit) = (id, suit) in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query suit)
  in
  wrapped

type user = { user_id: int; name: string }

type twoot = { twoot_id: int; content: string; likes: int }

let get_multiple_record_out =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int (tup2 string (tup2 int (tup2 string int))))
      [@ocaml.warning "-33"])
      "\n\
      \      SELECT users.user_id, users.name,\n\
      \             twoots.twoot_id, twoots.content, twoots.likes\n\
      \      FROM users\n\
      \      JOIN twoots ON twoots.user_id = users.user_id\n\
      \      ORDER BY users.user_id\n\
      \      "
  in
  let wrapped () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (user_id, (name, (twoot_id, (content, likes)))) =
        ({ name; user_id }, { likes; content; twoot_id })
      in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query ())
  in
  wrapped

let get_single_function_out loaders =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int string) [@ocaml.warning "-33"])
      "\n      SELECT id, name\n      FROM users\n      "
  in
  let wrapped loader () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (id, name) = loader ~name ~id in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query ())
  in
  wrapped loaders

let get_multiple_function_out loaders =
  let query =
    (let open Caqti_request in
    collect)
      ((let open Caqti_type in
       unit) [@ocaml.warning "-33"])
      ((let open Caqti_type in
       tup2 int (tup2 string (tup2 int (tup2 string int))))
      [@ocaml.warning "-33"])
      "\n\
      \      SELECT users.id, users.name,\n\
      \             twoots.id, twoots.content, twoots.likes\n\
      \      FROM users\n\
      \      JOIN twoots ON twoots.id = users.id\n\
      \      ORDER BY users.id\n\
      \      "
  in
  let wrapped (loader, loader') () (module Db : Rapper_helper.CONNECTION) =
    let f result =
      let g (users_id, (users_name, (twoots_id, (twoots_content, twoots_likes))))
          =
        ( loader ~id:users_id ~name:users_name,
          loader' ~id:twoots_id ~content:twoots_content ~likes:twoots_likes )
      in
      let f = Stdlib.List.map g in
      match result with Ok x -> Ok (f x) | Error e -> Error e
    in
    Rapper_helper.map f (Db.collect_list query ())
  in
  wrapped loaders
