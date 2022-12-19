// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class CreateUserMutation: GraphQLMutation {
  public static let operationName: String = "CreateUser"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation CreateUser($email: String!, $password: String!) {
        createUser(email: $email, password: $password) {
          __typename
          success
          id
        }
      }
      """
    ))

  public var email: String
  public var password: String

  public init(
    email: String,
    password: String
  ) {
    self.email = email
    self.password = password
  }

  public var __variables: Variables? { [
    "email": email,
    "password": password
  ] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("createUser", CreateUser?.self, arguments: [
        "email": .variable("email"),
        "password": .variable("password")
      ]),
    ] }

    /// User creation mutation
    public var createUser: CreateUser? { __data["createUser"] }

    /// CreateUser
    ///
    /// Parent Type: `CreateUser`
    public struct CreateUser: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.CreateUser }
      public static var __selections: [Selection] { [
        .field("success", Bool.self),
        .field("id", Aida.UUID?.self),
      ] }

      public var success: Bool { __data["success"] }
      public var id: Aida.UUID? { __data["id"] }
    }
  }
}
