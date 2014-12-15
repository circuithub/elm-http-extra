module Http.Extra where
{-| Convenience functions for working with Http
-}

import Http (..)
import Json.Decode as Json

{-| Apply a function to a successful response. If the result is Success, it will be altered. If the result is either Waiting or Failure it will stay the same.

    map .foo (Success (Foo {msg = "Hi!"})) == "Hi!"

-}
map : (a -> b) -> Response a -> Response b
map f r =
  case r of
    Success s          -> Success (f s)
    Waiting            -> Waiting
    Failure status msg -> Failure status msg

{-| Decode a Json response without first unwrapping it

  import Json.Decode as Json

  decodeResponse Json.string (Success "\"I'm a JSON encoded string\"") == Success "I'm a JSON encoded string"

-}
decodeResponse : Json.Decoder a -> Response String -> Response (Result String a)
decodeResponse d r = map (Json.decodeString d) r
