// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public typealias ID = String

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == Aida.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == Aida.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == Aida.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == Aida.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> Object? {
    switch typename {
    case "Query": return Aida.Objects.Query
    case "Profile": return Aida.Objects.Profile
    case "Mutation": return Aida.Objects.Mutation
    case "CreateUser": return Aida.Objects.CreateUser
    case "LoginUser": return Aida.Objects.LoginUser
    case "ResetPassword": return Aida.Objects.ResetPassword
    case "ValidateCode": return Aida.Objects.ValidateCode
    case "UpdatePassword": return Aida.Objects.UpdatePassword
    case "SendPasswordReset": return Aida.Objects.SendPasswordReset
    case "ResendValidationCode": return Aida.Objects.ResendValidationCode
    case "RefreshToken": return Aida.Objects.RefreshToken
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
