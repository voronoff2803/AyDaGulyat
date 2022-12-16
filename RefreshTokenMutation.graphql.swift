// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class RefreshTokenMutation: GraphQLMutation {
  public static let operationName: String = "RefreshToken"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation RefreshToken {
        refreshToken {
          __typename
          accessToken
        }
      }
      """
    ))

  public init() {}

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("refreshToken", RefreshToken?.self),
    ] }

    /// Refresh JWT access token
    public var refreshToken: RefreshToken? { __data["refreshToken"] }

    /// RefreshToken
    ///
    /// Parent Type: `RefreshToken`
    public struct RefreshToken: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.RefreshToken }
      public static var __selections: [Selection] { [
        .field("accessToken", String?.self),
      ] }

      public var accessToken: String? { __data["accessToken"] }
    }
  }
}
