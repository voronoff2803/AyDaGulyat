// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class LoginUserMutation: GraphQLMutation {
  public static let operationName: String = "LoginUser"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation LoginUser($email: String!, $password: String!) {
        loginUser(email: $email, password: $password) {
          __typename
          accessToken
          refreshToken
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
      .field("loginUser", LoginUser?.self, arguments: [
        "email": .variable("email"),
        "password": .variable("password")
      ]),
    ] }

    /// User login
    public var loginUser: LoginUser? { __data["loginUser"] }

    /// LoginUser
    ///
    /// Parent Type: `LoginUser`
    public struct LoginUser: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.LoginUser }
      public static var __selections: [Selection] { [
        .field("accessToken", String?.self),
        .field("refreshToken", String?.self),
      ] }

      public var accessToken: String? { __data["accessToken"] }
      public var refreshToken: String? { __data["refreshToken"] }
    }
  }
}
