// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI
import Aida

public class ValidateCodeMutation: GraphQLMutation {
  public static let operationName: String = "ValidateCode"
  public static let document: DocumentType = .notPersisted(
    definition: .init(
      """
      mutation ValidateCode($code: String!, $validateCodeId: String!) {
        validateCode(code: $code, id: $validateCodeId) {
          __typename
          accessToken
          refreshToken
        }
      }
      """
    ))

  public var code: String
  public var validateCodeId: String

  public init(
    code: String,
    validateCodeId: String
  ) {
    self.code = code
    self.validateCodeId = validateCodeId
  }

  public var __variables: Variables? { [
    "code": code,
    "validateCodeId": validateCodeId
  ] }

  public struct Data: Aida.SelectionSet {
    public let __data: DataDict
    public init(data: DataDict) { __data = data }

    public static var __parentType: ParentType { Aida.Objects.Mutation }
    public static var __selections: [Selection] { [
      .field("validateCode", ValidateCode?.self, arguments: [
        "code": .variable("code"),
        "id": .variable("validateCodeId")
      ]),
    ] }

    /// Validate the code & confirm the registration
    public var validateCode: ValidateCode? { __data["validateCode"] }

    /// ValidateCode
    ///
    /// Parent Type: `ValidateCode`
    public struct ValidateCode: Aida.SelectionSet {
      public let __data: DataDict
      public init(data: DataDict) { __data = data }

      public static var __parentType: ParentType { Aida.Objects.ValidateCode }
      public static var __selections: [Selection] { [
        .field("accessToken", String?.self),
        .field("refreshToken", String?.self),
      ] }

      public var accessToken: String? { __data["accessToken"] }
      public var refreshToken: String? { __data["refreshToken"] }
    }
  }
}
