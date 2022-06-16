use syn::{parse_macro_input, DeriveInput};
use quote::quote;

#[proc_macro_derive(AnimationTraits)]
pub fn derive_animation(input: proc_macro::TokenStream) -> proc_macro::TokenStream {
    let input = parse_macro_input!(input as DeriveInput);

    let name = input.ident;

    let expanded = quote! {
        impl Into<crate::Animation> for #name {

            fn into(self) -> crate::Animation {
                return crate::Animation::#name(self); 
            }
        }

        impl TryInto<#name> for crate::Animation {
            type Error = ();

            fn try_into(self) -> Result<#name, Self::Error> {
                match self {
                    crate::Animation::#name(animation) => Ok(animation),
                    _ => Err(())
                }
            }
        }

        impl #name {
            pub fn uuid(&self) -> Uuid { self.uuid }
        }

        assert_impl_all!(#name: std::fmt::Debug, PartialEq, crate::Layer);
        assert_fields!(#name: uuid);
    };

    proc_macro::TokenStream::from(expanded)
}

