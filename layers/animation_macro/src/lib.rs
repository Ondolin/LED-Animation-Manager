use syn::{parse_macro_input, DeriveInput};
use quote::quote;

#[proc_macro_derive(Animation)]
pub fn derive_animation(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    let name = input.ident;

    let expanded = quote! {
        impl Into<Animation> for #name {

            fn into(self) -> Animation {
                return Animation::#name(self); 
            }
        }

        impl TryInto<#name> for Animation {
            type Error = ();

            fn try_into(self) -> Result<#name, Self::Error> {
                match self {
                    Animation::#name(animation) => Ok(animation),
                    _ => Err(())
                }
            }
        }

        //TODO make this uuid
        impl #name {
            fn uuid(&self) -> String { self.uuid.clone() }
        }

        assert_impl_all!(#name: std::fmt::Debug, PartialEq, Eq, AnimationTrait);
        assert_fields!(#name: uuid);
    };

    proc_macro::TokenStream::from(expanded)
}

